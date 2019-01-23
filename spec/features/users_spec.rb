require 'spec_helper'

describe "users", :type => :feature do

  before :each do
    create_operator()
    @user = FactoryGirl.create(:superadmin_user)
    login_as(@user, :scope => :user)
  end

  describe "index" do

    it "shows list of users" do

      users = FactoryGirl.create_pair(:user)

      visit users_path()

      expect(page).to have_content users[0].email
      expect(page).to have_content users[1].email
    end

  end

  describe "CREATE user" do

    describe "valid" do

      it "shows created user" do

        user = form_attributes(:user)
        user[:password] = "order123123"
        user[:password_confirmation] = "order123123"

        visit new_user_path

        fill_attributes(:user, user)

        find("#new_user input[type=submit]").click()

        expect(page).to have_content user["email"]

      end

    end

    describe "invalid" do

      it "shows form with errors" do
        visit new_user_path

        user = {}
        # invalid value = empty value at least

        fill_attributes(:user, user)

        expect {
          find("#new_user input[type=submit]").click()
        }.to change(User, :count).by(0)
        # Check that form at least re-rendered

      end

    end

  end

  describe "UPDATE user" do

    it "updates user" do

      user = FactoryGirl.create(:user)
      visit edit_user_path(user)

      change = {email:"valid@email.ru"}

      fill_attributes(:user, change)
      find("[id^=edit_user] input[type=submit]").click()

      expect(user.reload.email).to eq(change[:email])

    end

  end

  describe "DELETE user" do

    it "deletes user" do
      user = FactoryGirl.create(:user)
      visit user_path(user)

      link = find('a[data-method="delete"][href^="/users"]')

      expect { link.click }.to change(User, :count).by(-1)

    end

  end

end
