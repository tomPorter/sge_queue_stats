require 'rubygems'
require 'sinatra/base'
require 'haml'
require_relative 'lib/queue_stat/data_mapper/setup'
class QueueStats <Sinatra::Base
  enable :sessions
  FILTER_FIELDS = [:state, :clientcode, :jobid, :user, :queue_name]
  helpers do 
    def get_help_text()
    "Hover over fields to find filter links.  Filter results by clicking on filter links. Clear by clicking on green heading field."
    end
      
    def set_filter_class(filter_type)
      if session.has_key? filter_type.to_sym
        'filtered'
      else
        'cleared'
      end
    end

    def gen_state_link(state_type)
      "<span class='#{state_type}'><a href='state/#{state_type}'>#{state_type}</a></span>"
    end

    def get_summary_counts()
      summary_hash = {}
      s = Job.all(:fields => [:state]).map {|j| j[:state]}
      ['r','qw','hqw','Eqw','s'].map {|state| summary_hash[state] = s.count(state) }
      sh = summary_hash.each.map {|k,v| "'#{gen_state_link(k)}': #{v}" }
      sh.join(' ')
    end
      
    def get_display_filters
      query_hash = {}
      FILTER_FIELDS.each do |filter_type|
        if session.has_key? filter_type
          query_hash[filter_type] = session[filter_type]
        end
      end
      query_hash
    end

    def main_page()   
      session[:start] ||= 10
      session[:refresh] ||= 30000
      session[:start] += 1
      #load_jobs(settings.environment,session[:start])
      instance_variable_names = Job.properties.map {|p| p.name.to_s }
      query_hash = get_display_filters
      summary_counts = get_summary_counts
      @jobs = Job.all(query_hash)
      haml :index,  :layout => (request.xhr? ? false : :layout),  :locals => {:active_filters => query_hash.keys, :refresh => session[:refresh], :instance_vars => instance_variable_names, :summary_counts => summary_counts}
      #haml :index
    end

    def assign_class(k,v)
      if FILTER_FIELDS.include? k
        "#{k} #{v}"
      else
        k
      end  
    end  
  end
  
  get '/slower' do
    session[:refresh] += 5000
    main_page
  end
  
  get '/faster' do
    if session[:refresh] >= 35000
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
