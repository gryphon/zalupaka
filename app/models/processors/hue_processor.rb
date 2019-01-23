class Processors::HueProcessor < Processor

  def estimate
    if (words.length > 2)
      return 5
    else
      return 0
    end
  end

  def process

    badwords = ["блядь", "сраный", "сука", "мразь"].shuffle
    badendings = ["понял?", "олень!", "лучше бы молчал вообще", "неудачник"].shuffle

    result = []

    words.each do |w|

      word = w[:word]

      if word.length > 3
        if Random.new.rand(100) > 50
          if word.start_with?("е")
            word = "ху#{word}"        
          else
            word = "хуе#{word}"        
          end
        end
      end 
      result.push(word)

      if Random.new.rand(100) > 50
        badword = badwords.shift()
        result.push(badword)
      end

    end

    if Random.new.rand(100) > 50
      result.push(",")
      result.push(badendings.shift)
    end

    return words_to_text(result)

  end

end
