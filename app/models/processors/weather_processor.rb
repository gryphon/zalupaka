class Processors::WeatherProcessor < Processor

  def estimate
    if (filter_words_by_lex("погода").length >= 1)
      return 10
    else
      return 0
    end
  end

  def process
    return I18n.interpolate(templates.shuffle[0], {obj: ""})
  end

  def templates
    ["погода для тебя сегодня хуевая", "прямо сейчас идет дождь из моей мочи на твой ебальник"]
  end

end
