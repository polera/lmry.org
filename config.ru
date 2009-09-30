require 'rubygems'
require 'sinatra'
 
 Sinatra::Application.default_options.merge!(
         :app_file => "main.rb",
                 :env      => :production,
                         :raise_errors => true,
                                 :run    => false
                                 )
  
  require "main"
  run Sinatra.application
   
