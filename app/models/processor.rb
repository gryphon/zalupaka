class Processor

  def initialize words
    @words = words
  end

  def self.processors
    Dir["#{File.dirname(__FILE__)}/processors/*.rb"].each {|file| load(file)}
    return Processors.constants.map(&Processors.method(:const_get)).map {|p| {class: p} }
  end

  def filter_words_by_type type
    @words.select{|item| item[:type] == type}
  end

  def filter_words_by_lex w
    if !w.kind_of?(Array)
      w = [w]
    end
    @words.select{|item| w.include?(item[:lex]) }
  end


  def words_to_text array
    array.join(" ")
  end

  def words
    @words
  end

end
