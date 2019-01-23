class Processors::AssProcessor < Processor

  def estimate
    if (filter_words_by_type("S").length == 1)
      return 5
    elsif (filter_words_by_type("S").length > 1)
      return 2
    else
      return 0
    end
  end

  def process
    objects = filter_words_by_type("S")
    return I18n.interpolate(templates.shuffle[0], {obj: objects[0][:lex]})
  end

  def templates
    ["%{obj} у тебя из жопы торчит", "засунь себе %{obj} в жопу", "да срал я на %{obj}"]
  end

end
