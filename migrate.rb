require 'rubygems'
require 'dm-core'

require 'lib/models.rb'

DataMapper.auto_migrate!

# Populate some sample data

destination = Destination.new
destination.attributes = {:hash=>'xk5d',:url=>'http://polera.org',:visit_count=>0, :created_at=>Time.now}
destination.save
