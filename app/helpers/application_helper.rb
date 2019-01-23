module ApplicationHelper

  def popover_hint text
    content_tag :i, class: "fa fa-question-circle", data: {toggle: "tooltip"}, title: text do
    end
  end

  def list_button icon, path, options = {}

    options[:class] = "btn-default" if options[:class].blank?
    options[:class] = ["btn btn-xs action", options[:class]]

    link_to path, options do
      content_tag(:i, "", :class=>["fa", icon])
    end
  end

  def head_button icon, path, label, options = {}

    options[:class] = "btn-default" if options[:class].blank?
    options[:class] = ["btn", options[:class]]

    link_to path, options do
      content_tag(:i, "", :class=>["fa", icon]) + content_tag(:span, " " + label)
    end
  end

  def current_account
    @account
  end

  def delete_button path
    begin
      link_to path, :method => :delete, :data => {:confirm => t("sure_delete")}, :title=>t("delete"), :class => "action btn btn-default btn-xs btn-danger" do
        content_tag :i, "", :class=>'fa fa-trash-o'
      end
    rescue NoMethodError
      # No route
      nil
    end
  end

  def edit_button path
    begin
      link_to path, :class => "action btn btn-xs btn-info", :title=>t("edit") do
        content_tag :i, "", :class=>'fa fa-pencil'
      end
    rescue NoMethodError
      # No route
      nil
    end
  end

  def key_button path
    link_to path, :class => "action btn btn-default btn-xs", :title=>t("users.switch_user") do
      content_tag :i, "", :class=>'fa fa-key'
    end
  end

  def download_button path, name=nil
    if can? :download, Document
      link_to path, :class => "action btn btn-success btn-xs", :title=>t("download"), :download => name do
        content_tag :i, "", :class=>'fa fa-download'
      end
    end
  end

  def download_button_text path, title, name=nil
    if can? :download, Document
      link_to path, :class => "action btn btn-default", :title=>t("download"), :download => name do
        capture do
          concat(content_tag :i, "", :class=>'fa fa-download')
          concat(title)
        end
      end
    end
  end


  def new_button path, label = nil, cls = "btn-success"
    label = t("new") if label.nil?
    link_to path, :class => "btn #{cls}" do
      content_tag(:i, "", :class=>'fa fa-plus') + content_tag(:span, " " + label)
    end
  end

  def delete_head_button path
    link_to path, :method => :delete, :data => {:confirm => t("sure_delete")}, :class => "btn btn-danger" do
      content_tag(:i, "", :class=>'fa fa-trash-o') + content_tag(:span, " "+t("delete"))
    end
  end

  def edit_head_button path, label=t("edit")
    link_to path, :class => "btn btn-default btn-info" do
      content_tag(:i, "", :class=>'fa fa-pencil') + content_tag(:span, " "+label)
    end
  end

  def back_head_button path
    link_to path, :class => "btn btn-default" do
      content_tag(:i, "", :class=>'fa fa-long-arrow-left') + content_tag(:span, " "+t("back"))
    end
  end  

  def boolean_icon value
    content_tag :i, "", :class=>(value ? "fa fa-lg fa-check success" : "fa fa-lg fa-times danger")
  end

  def date_value value
    icon = content_tag(:i, "", :class => "fa fa-calendar") + " "
    value = Time.parse(value) if value.kind_of?(String)
    if value.blank?
      result = icon + t("not_set")
    else
      result = icon + l(value, :format => I18n.t(:default, scope: 'date.formats'))
    end
    return content_tag(:span, result, :style => "white-space: nowrap;")
  end

  def datetime_value value
    l(value, :format => I18n.t(:long, scope: 'date.formats'))
  end

  def paid billing
    string = ""

    if billing.paid?
      string += boolean_icon(true)
    else
      string += boolean_icon(false)
    end

    if !billing.paid_usd.blank?
      string += content_tag(:i, "", :class => "fa fa-dollar")
      string += billing.paid_usd.to_s
    end

    if !billing.paid_rub.blank?
      string += content_tag(:i, "", :class => "fa fa-ruble")
      string += billing.paid_rub.to_s
    end

    return raw string

  end

  def datepicker f, name, placeholder="Select date"
    format = I18n.t(:short, scope: [:date, :datepicker], :default => :default)
    value = f.object.send(name).try(:strftime, I18n.t(format, scope: [ :date, :formats ], default: :default))

    f.text_field name, :class => "form-control bootstrap-datepicker",
     "data-provide" => "datepicker", 
     "data-date-format" => format, 
     "placeholder" => placeholder,
     :value => value
  end

  def datepicker_tag name, value, placeholder=t("select_date")
    format = I18n.t(:short, scope: [:date, :datepicker], :default => :default)

    text_field_tag name, value, :class => "form-control bootstrap-datepicker",
     "data-provide" => "datepicker", 
     "data-date-format" => format, 
     "placeholder" => placeholder
  end

  def horizontal_form_for(record, options={}, &block)
    options[:html] = {:class => "form-horizontal"}
    options[:wrapper] = :horizontal_form
    options[:wrapper_mappings] = {
      boolean: :horizontal_boolean, check_boxes: :horizontal_radio_and_checkboxes,
      radio_buttons: :horizontal_radio_and_checkboxes, file: :horizontal_file_input
    }
    return simple_form_for(record, options, &block)
  end

  def inline_form_for(record, options={}, &block)
    options[:html] = {:class => "form-inline"}
    options[:wrapper] = :vertical_form
    options[:wrapper_mappings] = {
      boolean: :horizontal_boolean, check_boxes: :horizontal_radio_and_checkboxes,
      radio_buttons: :horizontal_radio_and_checkboxes, file: :vertical_file_input
    }
    return simple_form_for(record, options, &block)
  end

  def vertical_form_for(record, options={}, &block)
    options[:html] = {:class => "form-vertical"}
    options[:wrapper] = :vertical_form
    options[:wrapper_mappings] = {
      boolean: :vertical_boolean, check_boxes: :vertical_radio_and_checkboxes,
      radio_buttons: :vertical_radio_and_checkboxes, file: :vertical_file_input
    }
    return simple_form_for(record, options, &block)
  end

  def fc c
    return number_to_currency(c, precision: 2, unit: "")
  end

  def cfc c
    return content_tag(:span, fc(c), class: ["amount", (c>=0 ? "positive" : "negative")])
  end

end
