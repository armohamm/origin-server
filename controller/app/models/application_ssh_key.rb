# Represents an autogenerated SSH key used by a component in the application to access other application gears.
# See {Application#process_commands}
class ApplicationSshKey < SshKey
  include Mongoid::Document
  embedded_in :application, class_name: Application.name
end
