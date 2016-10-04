require 'sinatra/base'

module Axle
  class Service < ::Sinatra::Base
    before do
      headers 'X-Powered-By' => "Axle #{Axle::Version}"
    end

    get "/" do
      
    end

    post "#{Axle.base_path}/play" do #need to implement API Versioning
      data = param['data']
      200
    end
  end
end