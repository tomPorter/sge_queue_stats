require 'data_mapper'
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/jobdatabase.db")
require_relative '../models/job.rb'
require_relative '../models/error.rb'
Job.auto_migrate! unless Job.storage_exists?
Error.auto_migrate! unless Error.storage_exists?
DataMapper.finalize if DataMapper.respond_to?(:finalize)
