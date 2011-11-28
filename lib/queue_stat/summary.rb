module Qstat
  class Summary < Array
    attr_reader :summary_lines
    def initialize()
      @summary_lines = get_summary_lines
    end

    def load_job_details!
      @summary_lines.map do |qstat_line|
        begin
          self << Qstat::Detail.new(qstat_line)
        rescue NoDetailDataFoundError
        end
      end
      nil
    end  

    #private
    def get_summary_lines
      cmd = "qstat -r"
      qstat_r_lines = CommandRunner.run(cmd)
      qstat_r_lines.shift(2)
      qstat_r_lines.select {|l| l[0] != ' '}
    end
  end
end
