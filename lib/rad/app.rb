require 'sinatra/base'
require 'haml'
require 'json'

module Rad
  class App < Sinatra::Base
    dir = File.dirname(File.expand_path(__FILE__))

    set :views,  "#{dir}/app/views"
    set :public, "#{dir}/app/public"
    set :static, true

    get '/' do
      haml :index
    end

    get '/resources' do
      api = Rad::Dsl.evaluate File.read(settings.radfile)
      content_type :json
      api.to_json
    end
  end
end
