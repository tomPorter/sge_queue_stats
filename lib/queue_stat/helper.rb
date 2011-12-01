module Qstat
  module Helper
    FILTER_FIELDS = [:state, :clientcode, :jobid, :user, :queue_name]
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
      haml :index, :ugly => true,  :layout => (request.xhr? ? false : :layout),  :locals => {:active_filters => query_hash.keys, :refresh => session[:refresh], :instance_vars => instance_variable_names, :summary_counts => summary_counts}
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
end  
