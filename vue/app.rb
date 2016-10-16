require "sinatra/base"

class App < Sinatra::Base
  configure :development do
    set :server, :puma
  end

  get "/" do
    #slim :index
    File.read(File.join('views', 'index.html'))
  end

  get "/game.js" do
    File.read(File.join('views', 'game.js'))
  end

  get "/game" do
    content_type :json

    {
      status: true,
      table: [
        { name: "Alice", age: 23, address: "New York" },
        { name: "Bob", age: 30, address: "San Francisco" },
      ]
    }.to_json
  end

  post "/game" do
    content_type :json
    params = JSON.parse(request.body.read)

    {
      status: true,
      table: [
        { name: "Alice", age: 23, address: "New York" },
        { name: "Bob", age: 30, address: "San Francisco" },
        params,
      ]
    }.to_json
  end
end