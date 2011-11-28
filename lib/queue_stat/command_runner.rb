module Qstat
	class InvalidQstatCommandError < Exception
	end
  class CommandRunner
    def CommandRunner.run(cmd)
      if cmd.start_with? 'qstat -j ' or cmd  == 'qstat -r'
        CommandRunner.get_command_output(cmd)
      else  
        raise InvalidQstatCommandError
      end
    end

    private
    def CommandRunner.get_command_output(cmd)
      env = ENV['RACK_ENV'] || 'prod'
      if env == 'prod'
        `#{cmd} 2>&1`.split("\n")
      else
        if cmd == 'qstat -r'
          output_file = File.join(File.dirname(__FILE__), '/../../test_qstat_output/qstat_r_output')
          raise InvalidQstatCommandError unless File.exists? output_file
          File.open(output_file,'r').read.split("\n")
        else
          qsid = cmd.split()[2]
          output_file = File.join(File.dirname(__FILE__),"/../../test_qstat_output/#{qsid}.detail")
          if File.exists? output_file
            File.open(output_file,'r').read.split("\n")
          else
            ['Following jobs do not exist',qsid]
          end
        end
      end
    end
  end
end
