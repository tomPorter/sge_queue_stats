require 'spec_helper'
module Qstat
  describe Detail, :quick => true  do
    before(:each) do
      @run_line          = '2559238 0.55500 x.jasperx. fooork       r     11/21/2011 05:04:59 Archive@archive02                  1        '
      @Eqw_line          = '2267638 0.55500 x.Okranaxx cardm        Eqw   10/05/2011 11:48:45                                    1        '
      @root_qw_line      = '2516302 0.55500 x.flickerw gross        qw    11/14/2011 08:00:22                                    1        '
			@normal_qw_line    = '2571632 0.00000 x.geniusde archiexd     qw    11/22/2011 16:17:59                                    1        '
      @hqw_line          = '2489626 0.00000 x.Rosiefoo floor        hqw   11/09/2011 14:57:53                                    1        '
      @s_line            = '2559238 0.55500 x.jasperx. fooork       s     11/21/2011 05:04:59 Archive@archive02                  1        '
      @non_existant_line = '1111111 0.00000 x.Rosiefoo floor        hqw   11/09/2011 14:57:53                                    1        '
    end

  	it "should throw an exception when no qstat -j line is found for a given qsid" do
		  lambda{Detail.new(@non_existant_line)}.should raise_error(NoDetailDataFoundError)
	  end

		it "should throw an exception if passed a mal-formed qstat line" do
		  lambda{Detail.new('foo bar')}.should raise_error(BadQstatLineError)
		end
    #it "should return a non-empty hash for each of the test_lines" do
    #  test_lines.each do |tl|
    #    q = Detail.new(tl)
    #    q.should be_a Hash
    #    q.size.should > 0
    #  end
    #end

    it "#get_run_time" do
      q = Detail.new(@run_line)
			q.get_run_time('11/23/2011','14:20:15').should match(/\d{3}:\d{2}/)
      d,t = DateTime.now.strftime("%m/%d/%Y %H:%M:%S").split
			q.get_run_time(d,t).should eq "000:00"
    end

    it "#get_queue_and_system" do
      q = Detail.new(@run_line)
      tokens = ['a','b','c','d','e','f','g','q@s','h']
      q.get_queue_and_system(tokens).should eq ['q','s']
      tokens = ['a','b','c','d','e','f','g','h']
      q.get_queue_and_system(tokens).should eq ['','']
    end

    it "#is_needed?" do
      q = Detail.new(@run_line)
      ['jid_predecessor_list','error','cwd:','job_name:','context:'].each do |token|
        line = '        ' + token + '  foo'
        q.is_needed?(line).should be_true
      end
      ['sge_o_email:','sge_o_foo:'].each do |token|
        line = '        ' + token + '  foo'
        q.is_needed?(line).should be_false
      end
    end

    it "#build_detail_hash empty" do
      q = Detail.new(@run_line)
      lines = []  #empty lines should not blow it up.
      q.build_detail_hash(lines).should be_a Hash
      q.build_detail_hash(lines).should == {}
    end

    it "#build_detail_hash three empty lines" do
      q = Detail.new(@run_line)
      lines = ['','','',]  #more than two lines of wrong kind should not blow up.
      q.build_detail_hash(lines).should be_a Hash
    end

    it "#build_detail_hash fqpn to command" do
      q = Detail.new(@run_line)
      lines = ['','cwd: /bar/baz','job_name: c_foo']  #Checking fqpn building
      h = q.build_detail_hash(lines)
      h.should have_key(:command)
      h[:command].should == '/bar/baz/c_foo'
    end

    #['cwd:','job_name:']
    it "#gen_detail_hash single entry" do
      q = Detail.new(@run_line)
      q.gen_detail_hash('cwd:     /bar/foo').should eq({cwd:'/bar/foo'})
      q.gen_detail_hash('job_name:     c_foo').should eq({job_name:'c_foo'})
    end

    #['jid_predecessor_list','error','context:']
    it "#gen_detail_hash error entry" do
      q = Detail.new(@run_line)
      
      error_line = "error reason    1:          10/05/2011 12:58:12 [2043:31116]: error: can't chdir to /IValue/22846: No such file or directory"
      eh = q.gen_detail_hash(error_line)
      eh.should have_key(:error_reason)
      eh[:error_reason].should match(/No such file or directory/)
    end

    it "#gen_detail_hash context entry" do
      q = Detail.new(@run_line)
      context_line = 'context:                    thread=1,error_email=yes'
      ch = q.gen_detail_hash(context_line)
      ch.should have_key(:thread)
      ch[:thread].should == '1'
    end

    it "#gen_detail_hash wait_qsid entry" do
      q = Detail.new(@run_line)
			jid_line = 'jid_predecessor_list (req):  2572146'
      wh = q.gen_detail_hash(jid_line)
      wh.should have_key(:wait_qsid)
		end

    it "should return a hash containing detail info about a job" do
      q = Detail.new(@run_line)
      q.should be_a Hash
    end
    #types = [:error_reason, :qsid, :state, :user, :start_date, :start_time, :run_time, :wait_qsid, :thread, :queue_name,:clientcode, :jobid, :command ]

    it "should return a hash with required keys for a 'run' state" do
      types = [:qsid, :state, :user, :start_date, :start_time, :run_time,  :thread, :queue_name,:clientcode, :jobid, :command ]
      q = Detail.new(@run_line)
      not_populated = types - q.keys
      not_populated.should == []
    end

    it "should return a hash with required keys for a root 'qw' state" do
      types = [:qsid, :state, :user, :start_date, :start_time,  :thread, :queue_name, :command ]
      q = Detail.new(@root_qw_line)
      not_populated = types - q.keys
      not_populated.should == []
	  end

    it "should return a hash with required keys for a normal 'qw' state" do
      types = [:qsid, :state, :user, :start_date, :start_time,  :thread, :queue_name,:clientcode, :jobid, :command ]
      q = Detail.new(@normal_qw_line)
      not_populated = types - q.keys
      not_populated.should == []
	  end
	
	
    it "should return a hash with required keys for a 'hqw' state" do
      types = [:wait_qsid, :qsid, :state, :user, :start_date, :start_time,  :thread, :queue_name,:clientcode, :jobid, :command ]
      q = Detail.new(@hqw_line)
      not_populated = types - q.keys
      (not_populated - [:clientcode,:jobid]).should == []
		end
		
    it "should return a hash with required keys for a 'Eqw' state" do
      types = [:error_reason,:qsid, :state, :user, :start_date, :start_time,  :thread, :queue_name,:clientcode, :jobid, :command ]
      q = Detail.new(@Eqw_line)
      not_populated = types - q.keys
      (not_populated - [:clientcode,:jobid]).should == []
	  end
	
    it "should return a hash with required keys for a 's' state" do
      types = [:qsid, :state, :user, :start_date, :start_time, :run_time,  :thread, :queue_name,:clientcode, :jobid, :command ]
      q = Detail.new(@s_line)
      not_populated = types - q.keys
      not_populated.should == []
    end
  end
end
