# -*- coding: utf-8 -*-
SimpleNavigation::Configuration.run do |navigation|

  navigation.consider_item_names_as_safe = true

  # Define the primary navigation
  navigation.items do |primary|

    if can? :index, Order
      primary.item :orders, t("orders.orders"), orders_path, highlights_on: :subpath
    end
    if can? :index, Cargo
      primary.item :cargos, t("cargos.cargos"), cargos_path, highlights_on: :subpath
    end

    if can?(:index, Bill) || can?(:index, Payment) || can?(:index, TransferBilling)
      primary.item :billings, t("billings.billings"), nil, highlights_on: %r(\A/customer_billings|\A/broker_billings|\A/payments|\A/transfer_billings) do |billings|
        #if can?(:index, Bill)
        #  billings.item :bills, t("bills.bills"), bills_path
        #end
        if can?(:customer, Bill)
          billings.item :customer_billings, t("bills.customer_billings"), customer_bills_path
        end
        if can?(:broker, Bill)
          billings.item :broker_billings, t("bills.broker_billings"), broker_bills_path
        end
        if can?(:index, Payment)
          billings.item :transfer_billings, t("payments.payments"), payments_path
        end
        if can?(:index, TransferBilling)
          billings.item :transfer_billings, t("transfer_billings.transfer_billings"), transfer_billings_path
        end
        if can?(:dividends, Bill)
          billings.item :dividends, t("bills.dividends"), dividends_bills_path
        end
        if can?(:index, Billing) && (["Broker", "Customer", "Agent"].include?(current_user.company.type))
          billings.item :statement, t("billings.statement"), company_billings_path(current_user.company)
        end
      end
    end

    if can?(:expenses, :analytics)
      primary.item :analytics, t("analytics.analytics"), nil, highlights_on: %r(/\Aanalytics) do |analytics|
        analytics.item :expenses, t("analytics.expenses"), analytics_expenses_path if can?(:expenses, :analytics)
        analytics.item :brokers, t("analytics.broker_expenses"), analytics_brokers_path if can?(:brokers, :analytics)
        analytics.item :customers, t("analytics.customers"), analytics_customers_path if can?(:customers, :analytics)
        analytics.item :banks, t("analytics.banks"), analytics_banks_path if can?(:banks, :analytics)
        analytics.item :income, t("analytics.income"), analytics_income_path if can?(:income, :analytics)
        analytics.item :orders, t("orders.orders"), analytics_orders_path if can?(:orders, :analytics)
        analytics.item :annual, t("analytics.annual"), analytics_annual_path if can?(:annual, :analytics)
        analytics.item :accountant, t("analytics.accountant"), analytics_accountant_path if can?(:accountant, :analytics)
      end
    end

    if !current_user.nil? && current_user.company.type == "Agent"
      if can?(:write, Customer)
        primary.item :customers, t("customers.customers"), customers_path if can?(:write, Customer)
      end
    end

    if can?(:write, User) || can?(:write, Customer) || can?(:admin, :admin)
      primary.item :admin, t('admin'), nil do |admin|
        admin.item :operators, t("operators.operators"), admin_operators_path if can?(:write, Operator)
        admin.item :agents, t("agents.agents"), agents_path if can?(:write, Agent)
        admin.item :customers, t("customers.customers"), customers_path if can?(:write, Customer)
        admin.item :brokers, t("brokers.brokers"), brokers_path if can?(:write, Broker)
        admin.item :users, t("users.users"), users_path if can?(:write, User)
        admin.item :destinations, t("destinations.destinations"), admin_destinations_path if can?(:write, Destination)
        admin.item :currencies, t("currencies.currencies"), admin_currencies_path if can?(:write, Currency)
        admin.item :banks, t("banks.banks"), admin_banks_path if can?(:write, Bank)
        admin.item :shareholders, t("shareholders.shareholders"), admin_shareholders_path if can?(:write, Shareholder)
        admin.item :announces, t("announces.announces"), admin_announces_path if can?(:write, Announce)
      end
    end

    primary.item :histories, t("histories.histories"), histories_path if can? :manage, PaperTrail::Version

  end
end
