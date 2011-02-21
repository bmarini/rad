require 'sinatra/base'
require 'haml'
require 'sass'
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

    get '/css/app.css' do
      scss :stylesheet
    end

    get '/resources' do
      content_type :json
      api.to_json
    end

    post '/proxy' do
      result = Rad::Proxy.request(api, params)
      content_type :json
      result.to_json
    end

    protected
    def api
      @api ||= Rad::Dsl.evaluate File.read(settings.radfile)
    end
  end
end
