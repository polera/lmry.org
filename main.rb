require 'rubygems'
require 'sinatra'

get '/redirect' do
  redirect 'http://www.google.com', 303
end

get '/' do
  @version = Sinatra::VERSION
  haml :index
end

get '/xml' do
  builder do |xml|
    xml.node do
      xml.subnode "Inner text"
    end
  end
end
