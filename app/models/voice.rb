class Voice

  def self.generate phrase

    words = Voice.stem(phrase)

    processors = Processor.processors

    processors.each do |processor|
      processor[:instance] = processor[:class].new(words)
      processor[:rank] = processor[:instance].estimate
      if processor[:rank] > 0
        processor[:result] = processor[:instance].process
      end
    end

    processors = processors.select{|item| item[:rank] > 0}.sort_by{|obj| obj[:rank]}.reverse

    #abort processors.map{|p| {class: p[:class], result: p[:result], rank: p[:rank]}}

    r = Random.new.rand(100)

    return processors[0][:result] if processors.length == 1
    return processors[1][:result] if r > 60
    return processors[2][:result] if r > 40 && processors.length >= 3
    return processors[0][:result]

  end

  def self.stem text
    stemmed = YandexMystem::Raw.stem text
    output = []
    stemmed.each do |s|
      w = s[:analysis][0]

      w[:type] = w[:gr].split(",")[0]

      w[:word] = s[:text]
      output.push(w)
    end
    output
  end



end