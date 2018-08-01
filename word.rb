require 'rwordnet'
require 'pry'
require 'fuzzy_match'
require 'yaml'

class EmojiNet
  def initialize
  syms = File.read("./emoji.txt").split("\n")
  @symbols = syms#["bowtie","mountain", "mouse", "bird", "smile", "confused", "smiling_imp", "man_with_turban", "cent"]
  @map = {}
  @out = {}
  end

  def wordnet_symbols
      wordnet_symbols = @symbols.map { |symbol|
        {symbol => WordNet::Lemma
          .find_all(symbol.gsub("_", " "))
        .map(&:synsets)
          .map{ |x|
          x.map(&:hyponyms).flatten.map(&:words).flatten.map{ |x| x.gsub("_", " ") }
        }
        .flatten
        .uniq
        }}
      wordnet_symbols.reduce Hash.new, :merge
  end

  def export_symbols
    yaml = wordnet_symbols.to_yaml
    File.write('./export.yml', yaml)
  end

  def read_exported_symbols
    YAML.load(File.read('./export.yml'))
  end

  def expand(phrase)
    result = []
    loaded_symbols = read_exported_symbols

    phrase.split.map { |word|
      # for each word in the phrase, find the most related set of words from the map of wordnet symbols
      weighted = loaded_symbols.map { |k,v|
          score = 0.0
          if k == word
            score = 1000.0 
          else
            unless v.empty?
              search = FuzzyMatch.new(v).find_all_with_score(word).map{|x|x[1]}
              score = search.take(3).sum() if search != nil && !search.empty?
            end
          end
          {
            k => score
          }
      }
      sorted = weighted.reduce(Hash.new, :merge).delete_if{|k,v|v == 0.0}.sort_by(&:last).reverse.to_h
      if(sorted.empty?)
        result << word
      else
        result << ":#{sorted.keys.first}:"
      end
    }
    result.join(" ")
  end

end
puts EmojiNet.new().expand(ARGV.first)

