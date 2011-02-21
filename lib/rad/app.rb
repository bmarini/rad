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
      content_type :json
      result = Rad::Proxy.request(api, params)

      { :status_code => result.code,
        :headers     => result.response.to_hash.map { |k,v| {:key => k, :val => v.first } },
        :body        => result.body }.to_json
    end

    protected
    def api
      @api ||= Rad::Dsl.evaluate File.read(settings.radfile)
    end
  end
end
