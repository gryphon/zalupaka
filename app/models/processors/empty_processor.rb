class Processors::EmptyProcessor < Processor

  def estimate
    if words.length==0
      return 10
    else
      return 0
    end
  end

  def process

    bad_empties = ["че молчишь, гандон?", "я твою мамку ебал", "боишься меня что ли, хуепутало?", "ну ка скажи что нибудь"].shuffle

    return bad_empties.shuffle[0]

  end


end
