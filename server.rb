require 'rails/commands/server'
require 'rack'

require 'webrick'
require 'webrick/https'

cert_name = [
  %w[CN op1.adqcargo.com],
]

if ENV['SSL'] == "true"
  module Rails
      class Server < ::Rack::Server
          def default_options
              super.merge({
                  :Port => 3000,
                  :environment => (ENV['RAILS_ENV'] || "development").dup,
                  :daemonize => false,
                  :debugger => false,
                  :pid => File.expand_path("tmp/pids/server.pid"),
                  :config => File.expand_path("config.ru"),
                  :SSLEnable => true,
                  :SSLCertName => cert_name,
              })
          end
      end
  end
end

APP_PATH = File.expand_path('../../config/application',  __FILE__)
require_relative '../config/boot'
require 'rails/commands'

