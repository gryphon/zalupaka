class Processors::OneProcessor < Processor

  def estimate
    if (words.length == 1)
      return 5
    end
    return 0
  end

  def process
    return I18n.interpolate(templates.shuffle[0], {obj: words[0][:lex]})
  end

  def templates
    ["%{obj} говно", "%{obj} залупа"]
  end

end
