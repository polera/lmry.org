require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'lib/models.rb'

@@POOL = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
@@site = ''


error do
    @error = request.env['sinatra.error'].message
    erb :error_page
end

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
  hashed_url = ""
  1.upto(3) { |x| hashed_url << @@POOL[rand(@@POOL.size - 1)] }
  @existing_destination = Destination.first(:url=>@url)
  if @existing_destination == nil
    @destination = Destination.new
    @destination.attributes = {:url_code=>hashed_url,
                               :url=>@url,
                               :created_by=>env['REMOTE_ADDR'],
                               :created_at=>Time.now}
    @destination.save
    @hash = hashed_url
  else
    @hash = @existing_destination.url_code
  end
  
  erb :new_url
end


post '/:redirect' do
  @dest = Destination.first(:url_code=>params['redirect'])
  @dest.visit_count += 1
  @dest.save
  @hit = @dest.hits.new(:remote_host=>env['REMOTE_ADDR'],
                        :referrer=>request.referrer,
                        :time_stamp=>Time.now)
  @hit.save
  redirect @dest.url, 301
end

get '/:redirect' do
  params['redirect']
  @referrer = request.referrer
  @dest = Destination.first(:url_code=>params['redirect'])
  if @dest == nil
    raise error 'No such URL found in our database.'
  end
  @dest.entry_count += 1
  @dest.save
  @visit_ratio = (@dest.visit_count/@dest.entry_count.to_f * 100).to_i
  erb :url_info
end

get '/' do
  @version = Sinatra::VERSION
  erb :index
end
