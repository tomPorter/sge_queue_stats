module Qstat
  module Helper
    FILTER_FIELDS = [:state, :clientcode, :jobid, :user, :queue_name]
    JOB_STATES = ['qw','hqw','hRwq','r','t','Rr','Rt','s','ts','S','tS','T','tT','Rs','Rts','RS','RtS','RT','RtT','Eqw','Ehqw','EhRqw','dr','dt','dRr','dRt','ds','dS','dT','dRs','dRS','dRT']
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
      if state_type == 'Ttl'
        "<span class='#{state_type}'>#{state_type}</span>"
      else
        "<span class='#{state_type}'><a href='state/#{state_type}'>#{state_type}</a></span>"
      end
    end

    def get_summary_counts()
      summary_hash = {}
      s = Job.all(:fields => [:state]).map {|j| j[:state]}
      JOB_STATES.map {|state| summary_hash[state] = s.count(state) } 
      total_count = summary_hash.each_value.reduce(:+)
      summary_hash['Ttl'] = total_count
      sh = summary_hash.each.map {|k,v| "'#{gen_state_link(k)}': #{v}" if v > 0 }
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
      session[:refresh] ||= 60000
      session[:start] += 1
      #load_jobs(settings.environment,session[:start])
      instance_variable_names = Job.properties.map {|p| p.name.to_s }
      query_hash = get_display_filters
      summary_counts = get_summary_counts
      @jobs = Job.all(query_hash)
      haml :index, :layout => (request.xhr? ? false : :layout),  :locals => {:active_filters => query_hash.keys, :refresh => session[:refresh], :instance_vars => instance_variable_names, :summary_counts => summary_counts}
      #haml :index, :locals => {:active_filters => query_hash.keys, :refresh => session[:refresh], :instance_vars => instance_variable_names, :summary_counts => summary_counts}
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
