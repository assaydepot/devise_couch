require 'devise_couch'
require 'devise/orm/couchrest_model/schema'
require 'devise/orm/couchrest_model/date_time'
require 'orm_adapter/adapters/couchrest_model'

module Devise
  module Orm
    module CouchrestModel
      module Hook
        def devise_modules_hook!
          extend Schema
          create_authentication_views
          yield
          devise_modules.each { |m| send(m) if respond_to?(m, true) }
        end

        private
        def create_authentication_views
          design do
            view :by_confirmation_token
            view :by_authentication_token
            view :by_reset_password_token
            view :by_unlock_token
            view :by_unconfirmed_email
          end
        end
      end
    end
  end
end

module CouchRest
  module Model
    class Base
      extend ::Devise::Models
      extend ::Devise::Orm::CouchrestModel::Hook
    end
  end
end
