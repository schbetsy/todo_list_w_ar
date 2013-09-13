require_relative 'config/application'
require_relative 'app/models/task.rb'
# puts "Put your application code in #{File.expand_path(__FILE__)}"

if ARGV.any?

  if ARGV[0] == "list"
    Task.list
  elsif ARGV[0] == "add"
    Task.create(title: ARGV[1..-1].join(" "))
  elsif ARGV[0] == "delete"
    Task.delete(ARGV[1])
  elsif ARGV[0] == "completed"
    Task.complete(ARGV[1])
  end
end
