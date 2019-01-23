FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user_#{n}" }
    sequence(:email) { |n| "email_#{n}@email.com" }
 
    password 'test123456'
    password_confirmation 'test123456'

    role :user

    association :company, factory: :customer

    factory :customer_user do
      role :user
      association :company, factory: :customer
    end

    factory :broker_user do
      role :user
      association :company, factory: :broker
    end

    factory :admin_user do
      role :sysadmin
      association :company, factory: :operator
    end

    factory :superadmin_user do
      role :superadmin
      association :company, factory: :operator
    end

  end
end