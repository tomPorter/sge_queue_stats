ToDo:
=====

-	Make `Qstat::CommandRunner` respond to `:test`, `:development` or `:prod` environments.  It should populate from
  output dir if not `:prod`, and should run actual command if is `:prod`.

-	`Qstat::CommandRunner` should throw `QstatCommandNotFoundError` if run in `:prod` mode and command does not exist.

-	Make `Qstat::Summary` and `Qstat::Detail` use `Qstat::CommandRunner`

- Anonymize output diretory contents so I can make project public again.
