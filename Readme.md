ToDo:
=====

-	Make `Qstat::CommandRunner` respond to `:test`, `:development` or `:prod` environments.  It should populate from
  output dir if not `:prod`, and should run actual command if is `:prod`.

-	`Qstat::CommandRunner` should throw `QstatCommandNotFoundError` if run in `:prod` mode and command does not exist.

- Write tests for `Qstat::Loader`
