require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'lib/models.rb'

@@POOL = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
@@site = 'http://lmry.org'

get '/xml' do
  builder do |xml|
    xml.node do
      xml.subnode "Inner text"
    end
  end
end

post '/save' do
  @site = @@site
  @url = params['url']
  @hash = ""
  1.upto(3) { |x| @hash << @@POOL[rand(@@POOL.size - 1)] }
  @destination = Destination.new
  @destination.attributes = {:hash=>@hash,:url=>@url,:visit_count=>0, :created_at=>Time.now}
  @destination.save
  erb :new_url
end


get '/:redirect' do
  params['redirect']
  @dest = Destination.first(:hash=>params['redirect'])
  @dest.visit_count += 1
  @dest.save
  @hit = @dest.hits.new(:remote_host=>env['REMOTE_ADDR'],
                               :referrer=>request.referrer,
                               :time_stamp=>Time.now)
  @hit.save
  redirect @dest.url, 301
end

get '/' do
  @version = Sinatra::VERSION
  erb :index
end
