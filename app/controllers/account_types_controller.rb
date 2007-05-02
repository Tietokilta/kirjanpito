class AccountTypesController < ApplicationController
  active_scaffold :account_type do |config|
    config.columns = [:id, :description]
  end
end
