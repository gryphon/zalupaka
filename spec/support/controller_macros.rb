module ControllerMacros

  def login_admin
    before(:each) do
      @operator = FactoryGirl.create(:operator)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      user = FactoryGirl.create(:admin_user, company: @operator)
      sign_in FactoryGirl.create(:admin_user, company: @operator) # Using factory girl as an example
    end
  end

  def login_customer
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      customer = FactoryGirl.create(:customer)
      user = FactoryGirl.create(:user, :role => :user, :company => customer)
      sign_in user
    end
  end

  def login_broker
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      broker = FactoryGirl.create(:broker)
      user = FactoryGirl.create(:user, :role => :user, :company => broker)
      sign_in user
    end
  end

  def setup_cancan
    before(:each) do
      @ability = Object.new
      @ability.extend(CanCan::Ability)
      controller.stub(:current_ability) { @ability }
    end
  end

end

module RequestDeviseMacros

  # for use in request specs
  def login_admin
    before(:each) do
      @operator = FactoryGirl.create(:operator)
      @user ||= FactoryGirl.create :admin_user, company: @operator
      post_via_redirect user_session_url(host: "http://#{@operator.hostname}"), 'user[email]' => @user.email, 'user[password]' => @user.password
    end
  end
end
