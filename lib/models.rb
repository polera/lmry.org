DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/lmry.db")

class Destination
  include DataMapper::Resource 
  property :id,          Serial
  property :url_code,        String, :key => true
  property :url,         Text
  property :visit_count, Integer, :default => 0
  property :entry_count, Integer, :default => 0
  property :created_at,  DateTime
  property :created_by,  String
  has n, :hits
end

class Hit
  include DataMapper::Resource
  property :id,          Serial
  property :remote_host,  String
  property :referrer,     String
  property :time_stamp,   DateTime
  belongs_to :destination
end