require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'lib/models.rb'

@@POOL = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a

get '/info' do
  env['REMOTE_ADDR']
end

get '/xml' do
  builder do |xml|
    xml.node do
      xml.subnode "Inner text"
    end
  end
end

post '/save' do
  url = params['url']
  hash = ""
  1.upto(3) { |x| hash << @@POOL[rand(24)] }
  destination = Destination.new
  destination.attributes = {:hash=>hash,:url=>url,:visit_count=>0, :created_at=>Time.now}
  destination.save
  "Your url is http://lmry.org/#{hash}"
end


get '/:redirect' do
  params['redirect']
  dest = Destination.first(:hash=>params['redirect'])
  dest.visit_count += 1
  dest.save
  redirect dest.url, 301
end

get '/' do
  @version = Sinatra::VERSION
  erb :index
end
