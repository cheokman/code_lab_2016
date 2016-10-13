require 'sinatra/base'

module Axle
  class Service < ::Sinatra::Base
    include ServiceAdapter
    attr_reader :type, :format

    before do
      headers 'X-Powered-By' => "Axle #{Axle::VERSION}"
      format :json
    end

    get "/check.?:format?" do
      @process_result = default_process_result
      format params[:format].to_sym unless params[:format].nil?
      @process_result[:response] = "OK #{format}"
      respond_with_result
    end

    post "#{Axle.service_base_path}/messages/create.?:format?" do #need to implement API Versioning
      @type = "action"
      process_message
      respond_with_result
    end

    def format(value=nil)
      if value.nil?
        self.class.format
      else
        self.class.format = value
      end
    end

    private
    def extract_message_data
      data = params[:msg]
      data
    end

    def request_info
      {"host" => request.host,"ip" => request.ip, "type" => @type}
    end
  end
end