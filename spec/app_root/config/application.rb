require "action_controller/railtie"

module TestApp
  class Application < Rails::Application
    config.root = File.join(File.expand_path('.'), 'spec', 'app_root')
    config.cache_classes = false
    config.whiny_nils = true
    config.secret_token = 'd229e4d22437432705ab3985d4d246'
    config.session_store :cookie_store, :key => 'rails_session'
    config.active_support.deprecation = :stderr
  end
end
