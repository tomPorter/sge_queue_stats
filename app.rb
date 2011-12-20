require 'rubygems'
require 'sinatra/base'
require 'haml'
require 'logger'
require_relative 'lib/queue_stat/data_mapper/setup'
require_relative 'lib/queue_stat/helper'
class QueueStats <Sinatra::Base
  enable :sessions, :logging
  set :haml, {:ugly => true}
  helpers Qstat::Helper 

  get '/slower' do
    session[:refresh] += 5000
    main_page
  end
  
  get '/faster' do
    if session[:refresh] >= 20000
      session[:refresh] -= 5000
    end
    main_page
  end
  
  get '/*/*' do  
    filter_string, filter_value = params[:splat]
    filter_type = filter_string.to_sym
    if FILTER_FIELDS.include? filter_type
      if filter_value == 'reset'
        if session.has_key? filter_type
          session.delete(filter_type)
        end  
      else
        session[filter_type] = filter_value
      end
    end
    redirect '/'
  end
  
  get '/' do
    main_page
  end
end  
