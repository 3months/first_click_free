module FirstClickFree
  require 'first_click_free/exceptions/subsequent_access_exception'
  require 'first_click_free/helpers/google'
  require 'first_click_free/helpers/path'
  require 'first_click_free/helpers/referrer'
  require 'first_click_free/concerns/controller'

  class << self

    require 'yaml'

    attr_accessor :test_mode, :permitted_paths, :free_clicks, :raise_excaption

    def root
      File.expand_path(File.join(File.dirname(__FILE__), '..'))
    end

    def permitted_domains
      @permitted_domains ||= YAML.load_file(File.join(FirstClickFree.root, 'config', 'domains.yml'))
    end

    def permitted_paths
      @permitted_paths || []
    end

    def free_clicks
      @free_clicks || 1 # default is 1 click free
    end

    def raise_excaption?
      @raise_excaption || false # default is false
    end

    def test_mode
      @test_mode || false
    end
  end

  class Railtie < Rails::Railtie
    initializer "first_click_free.action_controller" do
      ActiveSupport.on_load(:action_controller) do
        include FirstClickFree::Concerns::Controller
      end
    end
  end
end
