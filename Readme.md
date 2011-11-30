Queue Stats
===========

Displays output from the [Sun Grid Engine](http://wikis.sun.com/display/GridEngine/Home) `qstat` command in a periodically 
refreshed page.

Uses a sqlite file-based database to store `qstat` results.  Page requests 
hit DB for job status information.

I am using Sass for CSS generation.  
`cd public ; sass app.scss app.css ; cd ..` to regenerate.

All tests run against mocked up data stored in `test_qstat_output` directory.  
You do not have to have SGE installed to run tests.

You _must_ have the `bundler` gem installed and be using `rvm` to make this 
a painless process.  I am using ruby-1.9.3.

`bundle install` to install all needed gems.

`ruby em_get_jobs.rb` to start EventMachine background task and `QueueStats` 
Sinatra app. This displays output from actual `qstat` command.

To run in test mode (and use dummy data): `RACK_ENV=test ruby em_get_jobs.rb`

`localhost:3000` is address of app.

Note:
=====

SGE allows customization of data captured about each job.  The models, the index view, 
the tests, and the methods in `Qstat::Detail` all reflect my particular setup.  
These should not be too hard to modify to fit your particular situation.  

ToDo:
=====

-	`Qstat::CommandRunner` should throw `QstatCommandNotFoundError` if run in `prod` 
  mode and `qstat` command does not exist.

- Write tests for `Qstat::Loader`

- Add a 'Freeze' function to toggle refresh on/off.

-	Add total count of all jobs on system to top status line.

- Figure out best way to display error reason associated with jobs in `Eqw` state.

- Figure out a way to dynamically adjust the `eventmachine` periodic timer setting.

- Figure out how to combine `em_get_jobs.rb` and `config.ru`.  Running `em_get_jobs.rb` 
  as a config.ru causes weird errors since there is NOT an app run at the end of the file.
