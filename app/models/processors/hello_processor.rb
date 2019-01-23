class Processors::HelloProcessor < Processor

  def estimate
    if filter_words_by_lex(["привет", "здравствуйте"]).length > 0
      return 10
    end
    return 0
  end

  def process
    return I18n.interpolate(templates.shuffle[0], {obj: ""})
  end

  def templates
    ["привет, говно", "да иди ты нахуй", "с петухами не здороваюсь"]
  end

end
