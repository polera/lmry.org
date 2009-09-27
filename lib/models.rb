DataMapper.setup(:default, "sqlite3:///#{Dir.pwd}/lmry.db")

class Destination
  include DataMapper::Resource 
  property :id,          Serial
  property :hash,        String, :key => true
  property :url,         Text
  property :visit_count, Integer
  property :created_at,  DateTime
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