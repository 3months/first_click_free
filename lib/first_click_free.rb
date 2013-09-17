module FirstClickFree
  require 'first_click_free/exceptions/subsequent_access_exception'
  require 'first_click_free/helpers/google'
  require 'first_click_free/concerns/controller'

  class Railtie < Rails::Railtie
    initializer "first_click_free.action_controller" do
      ActiveSupport.on_load(:action_controller) do
        include FirstClickFree::Concerns::Controller
      end
    end
  end
end
