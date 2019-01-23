module Helpers

  def form_attributes model
    fields = build(model).attributes.delete_if { |k, v| v.nil? }
    return fields
  end

  def fill_attributes model, fields=nil
    fields = form_attributes(model) if fields.nil?
    fields.each do |k,v|

      element = all("##{model.to_s}_#{k}")[0]
      element = all("##{k}")[0] if element.nil?

      if element.nil?
        puts "No #{k} found on form"
        next
      end

      if element.tag_name == "select"
        element.find("option[value='#{v}']").select_option
      else
        element.set(v)
      end


    end
    return fields
  end

end