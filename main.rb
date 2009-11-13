require 'rubygems'
require 'sinatra'
require 'dm-core'
require 'dm-aggregates'
require 'lib/models.rb'

@@POOL = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
@@site = 'http://lmry.org'


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
  @existing_destination = Destination.first(:url=>@url)
  if @existing_destination == nil
    @destination = Destination.new
    hashed_url = ""
    
    # Make sure our generated URL doesn't exist already...
    1.upto(4) { |x| hashed_url << @@POOL[rand(@@POOL.size - 1)] } until \
    Destination.first(:url_code=>hashed_url) == nil and hashed_url.length > 0
    # Set new destination's attributes
    @destination.attributes = {:url_code=>hashed_url,
                               :url=>@url,
                               :created_by=>env['REMOTE_ADDR'],
                               :created_at=>Time.now}
    if @destination.save == false
      @error = true
    else
      @hash = hashed_url
    end
  else
    @recycled_link = true
    @hash = @existing_destination.url_code
  end
  erb :new_url
end

get '/stats/:redirect' do
  @dest = Destination.first(:url_code=>params['redirect'])
  if @dest == nil
    raise error 'No such URL found in our database.'
  else
    erb :extended_stats
  end
end

post '/:redirect' do
  @dest = Destination.first(:url_code=>params['redirect'])
  @dest.visit_count += 1
  @dest.save
  @hit = @dest.hits.new(:remote_host=>env['REMOTE_ADDR'],
                        :referrer=>params['referrer'],
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

get '/data/listing' do
    @destinations = Destination.all()
    erb :listing
end

get '/' do
  @version = Sinatra::VERSION
  erb :index
end
