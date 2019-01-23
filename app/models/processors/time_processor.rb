class Processors::TimeProcessor < Processor

  def estimate
    if (filter_words_by_lex(["время", "дата"]).length >= 1) && (filter_words_by_lex(["сколько", "сегодня", "сейчас"]).length >= 1)
      return 10
    else
      return 0
    end
  end

  def process
    return I18n.interpolate(templates.shuffle[0], {obj: ""})
  end

  def templates
    ["время дать тебе пизды", "сейчас на часах столько сколько раз я тебя обоссал"]
  end

end
