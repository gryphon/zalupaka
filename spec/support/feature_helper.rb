module FeatureHelper

  def create_operator
    @operator = FactoryGirl.create(:operator)
    #default_url_options[:host] = @operator.hostname
    #Capybara.default_host = @operator.hostname
    Capybara.app_host = "http://#{@operator.hostname}"
  end

end