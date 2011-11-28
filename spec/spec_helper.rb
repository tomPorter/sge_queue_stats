require 'queue_stat'
ENV['RACK_ENV'] = 'test'
def test_lines
  output_file = File.join(File.dirname(__FILE__), '/../test_qstat_output/qstat_r_output')
  test_lines =  File.open(output_file,'r').read.split("\n")
  test_lines.shift(2)
  test_lines.reject {|l| l.start_with? ' '}
end
