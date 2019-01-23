class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    user ||= User.new # guest user (not logged in)

    alias_action :create, :read, :update, :destroy, :to => :crud

    can :refresh, Currency

    if !user.new_record?
      can [:read, :settings, :password], User, :id => user.id
      can :read, CurrencyRate
      can :name, Company
    end

    if user.role == :demo
      can :read, Order, operator_id: user.company_id
      can [:read, :compose], Cargo, operator_id: user.company_id
      can :read, Customer, operator_id: user.company_id
      can :read, Broker, operator_id: user.company_id
      can :read, Billing, operator_id: user.company_id
      can [:broker, :customer, :stats], Bill, operator_id: user.company_id

      cannot :name, Company
      cannot :read, TransferBilling
    end

    if user.role == :spectator
      can :read, Order, operator_id: user.company_id
      can :read, Cargo, operator_id: user.company_id
      can :read, Content
      can :read, Box
      can :read, Customer, operator_id: user.company_id
      can :read, Broker, operator_id: user.company_id
      can :read, Comment
    end

    if user.company_id? && user.company.type == "Operator"

      can :read, Announce

      if user.role == :superadmin
        can :read, :all
        can :manage, :all
      end

      if user.role == :admin || user.role == :sysadmin
        can :manage, Customer, operator_id: user.company_id
        can :manage, Agent, operator_id: user.company_id
        can :manage, Company, operator_id: user.company_id # This is for company selector in users form
        can :manage, Announce
        
        can :manage, Order, operator_id: user.company_id
        can :manage, Cargo, operator_id: user.company_id

        # Allows to manage all related billings
        can :manage, Billing, company_to_id: user.company_id
        can :manage, Billing, company_from_id: user.company_id

        can :new, Billing

        can :manage, Content
        can :manage, Box

        can :manage, Fare

        can :manage, :analytics

        can :manage, Broker, operator_id: user.company_id
        can :manage, BrokerFare
        can :manage, Bank, operator_id: user.company_id
        can :manage, Shareholder, operator_id: user.company_id
        can :manage, Document

        can :manage, User, company: {operator_id: user.company_id}
        can :new, User

        can [:read, :create, :private], Comment

        can :read, Balance

      end

      if user.role == :admin
        cannot :destroy, User
        cannot :manage, User, role_cd: [User.roles[:sysadmin], User.roles[:superadmin]]
        cannot :manage, Operator
        cannot :switch, User
        can :manage, PaperTrail::Version, operator_id: user.company_id
      end

      if user.role == :sysadmin
        can :manage, Currency
        can :manage, CurrencyRate
        can :manage, Destination
        can :manage, Operator
        can :manage, PaperTrail::Version
        cannot :destroy, User
        cannot :manage, User, role_cd: [User.roles[:superadmin]]
      end

      if user.role == :manager

        #can :manage, Billing, company_from_id: user.company_id
        #can :manage, Billing, company_to_id: user.company_id

        can [:read, :write], Customer, operator_id: user.company_id
        can [:read], Broker, operator_id: user.company_id
        can [:read, :create], Company, operator_id: user.company_id # This is for company selector in users form

        can :create, Payment, company_from_id: user.company_id
        can :create, Payment, company_to_id: user.company_id

        can [:manage, :status], Order, operator_id: user.company_id
        can [:manage, :status], Cargo, operator_id: user.company_id
        can :show_fare_details, Order
        can :show_fare, Order
        can [:read, :create, :private], Comment

        can :manage, Document
        cannot :download, Document

        can :read, Destination
        can :manage, Fare
        can :manage, Content
        can :manage, Box
        
        can :customer, Bill
        can [:read, :create, :new], Billing, company_to_id: user.company_id, company_from_type: ["Customer"]
        can [:read, :create, :new], Billing, company_from_id: user.company_id, company_to_type: ["Customer"]

        cannot :read, TransferBilling

        #can [:read], User, operator_id: user.company_id

      end

      if user.role == :accountant

        can :manage, Billing, company_from_id: user.company_id
        can :manage, Billing, company_to_id: user.company_id

        can :read, Document
        
        can :manage, :analytics
        cannot :annual, :analytics
        cannot :orders, :analytics

        can [:read], Order, operator_id: user.company_id
        can [:read, :compose], Cargo, operator_id: user.company_id

        can :read, Bank, operator_id: user.company_id
        can :admin, :admin
                
        can :read, BrokerFare
        can :read, Company, operator_id: user.company_id
        can :read, Customer, operator_id: user.company_id
        can :read, Agent, operator_id: user.company_id
        can :read, Broker, operator_id: user.company_id
        #can :read, Order
        #can :show_fare_details, Order
        can :show_fare, Order
        can :notify, Bill
        can [:read, :create, :private], Comment
      end

      if user.role == :logist
        can [:read, :status], Order, operator_id: user.company_id
        can [:read, :compose, :status], Cargo, operator_id: user.company_id

        can :manage, Bill, company_from_id: user.company_id
        can :manage, Bill, company_to_id: user.company_id

        can :manage, Payment, company_from_id: user.company_id
        can :manage, Payment, company_to_id: user.company_id

        can :read, Content
        can :read, Box
        can :read, Company, operator_id: user.company_id
        can :read, Customer, operator_id: user.company_id
        can :read, Broker, operator_id: user.company_id
        can :manage, Document
        can :update, Cargo, operator_id: user.company_id
        can [:read, :create, :private], Comment

        cannot :dividends, Bill

      end

      if user.role == :sales
        can [:read, :status], Order, :customer => { :role_cd => Customer.roles(:order) }
        can :read, Content
        can :read, Box
        can :read, Customer, operator_id: user.company_id
        can :read, Document
        can :destroy, Document, :user_id => user.id
        can [:read, :create, :private], Comment
      end

    end

    if user.company_id? && user.company.type == "Customer"

      can :read, Announce, restriction: [nil, "Customer"]

      if user.role == :user

        can :read, Order, :customer_id => user.company_id
        can :read, Box, :order => { :customer_id => user.company_id }
        can :read, Content, :order => { :customer_id => user.company_id }      
        can :show, Customer, :id => user.company_id

        # Can read belonging payments
        can :read, Billing, :company_to_id => user.company_id
        can :read, Billing, :company_from_id => user.company_id

        can :customer, Bill, :company_to_id => user.company_id
        can :customer, Bill, :company_from_id => user.company_id

        can :create, Comment
        can :read, Comment, :private => false

        can :read, Document, :private => false

        if user.company.agent.nil?
          # Shows direct fare if there is no agent
          can :show_fare, Order, :customer_id => user.company_id
          can :show_fare_details, Order if user.company.show_fare_details == true
        else
          # Shows agent fare if customer has agent
          can :show_agent_fare, Order, :customer_id => user.company_id
          can :show_agent_fare_details, Order if user.company.show_fare_details == true
        end

        cannot :read, TransferBilling

      end

      if user.role == :analyst

        can :read, Order, :customer_id => user.company_id
        can :read, Box, :order => { :customer_id => user.company_id }
        can :read, Content, :order => { :customer_id => user.company_id }      
        can :show, Customer, :id => user.company_id
        can :create, Comment
        can :read, Comment, :private => false

      end
    end

    if user.company_id? && user.company.type == "Agent"

      can :read, Announce, restriction: [nil, "Agent"]

      if user.role == :user

        can :read, Box, :order => { :customer_id => user.company.customer_ids }
        can :read, Content, :order => { :customer_id => user.company.customer_ids }      
        can :show, Agent, :id => user.company_id

        # Allows to read all related billings
        can :read, Billing, :company_to_id => user.company_id
        can :read, Billing, :company_from_id => user.company_id

        can :customer, Bill, :company_to_id => user.company_id
        can :customer, Bill, :company_from_id => user.company_id

        # Allows to manage all related billings
        can :manage, Bill, {company_from_id: user.company_id, company_to_id: [nil]+user.company.customer_ids}
        # Allows to manage payments from its customers
        can :manage, Payment, {company_from_id: [nil]+user.company.customer_ids, company_to_id: user.company_id}

        # Can create new payments and bills to own customers
        can :new, Payment
        can :new, Bill

        can :create, Comment
        can :read, Comment, :private => false

        # Like a customer!
        can :show_fare, Order, :customer => user.company.customers
        can :show_fare_details, Order if user.company.show_fare_details == true

        # But more serious
        can :show_agent_fare, Order
        can :show_agent_fare_details, Order

        can :manage, Customer, parent_id: user.company_id
        can :read, Company, parent_id: user.company_id

        can :manage, Document

        can [:crud, :fares], Order, customer_id: user.company.customer_ids, operator_id: user.company.operator_id
        can :new, Order

        can :manage, Fare, {company_to_id: user.company.customer_ids, company_from_id: user.company.id}

        can :crud, User, {company_id: user.company.customer_ids, role_cd: 1}
        can :read, User, {company_id: user.company.customer_ids}

        cannot :broker, Bill
        cannot :dividends, Bill
        cannot :manage, TransferBilling
        cannot :manage, Broker
        cannot :manage, Bank

      end
    end

    if user.company_id? && user.company.type == "Broker"

      can :read, Announce, restriction: [nil, "Broker"]

      can :read, Cargo, :broker_id => user.company_id

      can :read, Document, :private => false

      can :status, Cargo do |cargo|
        (cargo.broker_id == user.company_id) && (cargo.status_cd >= Cargo.statuses[:sent])
      end
      can :show, Broker, :id => user.company_id

      # Can read belonging bills
      can :broker, Bill, :company_to_id => user.company_id
      can :broker, Bill, :company_from_id => user.company_id

      # Can read belonging payments
      can :read, Billing, :company_to_id => user.company_id
      can :read, Billing, :company_from_id => user.company_id

      cannot :manage, TransferBilling

      can :create, Comment
      can :read, Comment, :private => false
      can :read, Content#, :order => { :cargo => { :broker_id => user.company_id } }
      can :read, Box#, :order => { :cargo => { :broker_id => user.company_id } }
    end

  end
end
