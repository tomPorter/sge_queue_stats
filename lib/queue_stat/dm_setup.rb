require 'data_mapper'
DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/jobdatabase.db")
require_relative 'models/all_models.rb'
Job.auto_migrate! unless Job.storage_exists?
Error.auto_migrate! unless Error.storage_exists?
DataMapper.finalize if DataMapper.respond_to?(:finalize)
