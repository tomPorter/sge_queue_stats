class Error
  include DataMapper::Resource
  property :id, Serial
  property :error_message, Text
  belongs_to :job
end
