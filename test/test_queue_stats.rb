require 'test/unit'
require 'rack/test'
require_relative '../app'
ENV['RACK_ENV'] = 'test'
#set :environment, :test

class MyAppTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    QueueStats
  end

  def test_header
    get '/'
    assert last_response.ok?
  end

end
