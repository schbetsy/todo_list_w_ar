require 'csv'
 
class Task
  attr_reader :task, :complete
 
  def initialize(task)
    @task = task[0]
    @complete = complete?
  end
 
  def mark_complete!
    unless @complete
      @complete = true
      @task = @task << " -- Finished!"
    end
  end
 
  def to_s
    task
  end
 
  private
 
  def complete?
    return task =~ / -- Finished!/
  end
 
end
 
 
 
 
class List
  attr_reader :file
 
  def initialize(file)
    @contents = []
    @file = file
    load_file!
  end
 
  def list
    disp_list = []
    contents.each_with_index { |task, index| disp_list << "#{index}. #{task}"}
    disp_list
  end
 
  def add_task!(task)
    if task.class == Task
      puts "Adding \"#{task.name}\" to your TODO list."
      contents << task
    elsif task.class == String
      puts "Adding \"#{task}\" to you TODO list."
      contents << Task.new([task])
    end
    save_file!
  end
 
  def delete_task!(task)
    if task.class == Task
      puts "Deleting \"#{task.name}'\" from your TODO list."
      contents.delete(task)
    elsif task.to_i > 0 
      puts "Deleting \"#{contents[task.to_i].task}\" from your TODO list."
      contents.delete_at(task.to_i)
    end
    save_file!
  end
 
  def complete_task!(task)
    if task.class == Task
      puts "Marking \"#{task.name}'\" as completed."
      task.mark_complete!
    elsif task.to_i > 0 
      puts "Marking \"#{contents[task.to_i].task}\" as completed."
      contents[task.to_i].mark_complete!
    end
    save_file!
  end
 
 
  private
  attr_reader :contents
 
  def load_file!
    CSV.foreach(file) do |line|
      @contents << Task.new(line)
    end
  end
 
  def save_file!
    CSV.open(file, 'w') do |info|
      contents.each {|task| info << [task.task]}
    end
  end
 
end
 
 
 
 
class Controller
 
  def initialize(file)
    @task_list = List.new(file)
  end
 
  def go!(inputs)
    if inputs.any?
      command = ARGV[0].downcase
      task_name = ARGV[1..-1].join(" ")
      process_input(command, task_name)
    else
      # clear_screen!
      while true
        display_menu
        input = gets.chomp.downcase
        break if input == ""
        process_input(input)
      end
    end
  end
 
  private
  attr_reader :task_list
 
  def clear_screen!
    print "\e[2J"
  end
 
  def display_menu
    puts
    puts
    puts "What would you like to do?"
    puts "a. View your TODO list"
    puts "b. Add a task to your list"
    puts "c. Remove a task from your list"
    puts "d. Mark a task as completed"
    puts "Press enter to exit."
    puts 
    print "Your choice > "
  end
 
  def display_list
    # clear_screen!
    puts
    puts "Your Tasks:"
    puts
    puts task_list.list
  end
 
  def add_task(task)
    if task == ""
      print "What task do you want to add? > "
      task = gets.chomp
    end
    task_list.add_task!(task)
  end
 
  def remove_task(task)
    if task == ""
      print "What task do you want to delete? > "
      task = gets.chomp
    end
    task_list.delete_task!(task)
  end
 
  def complete_task(task)
    if task == ""
      print "What task do you want to mark as completed? > "
      task = gets.chomp
    end
    task_list.complete_task!(task)
  end
 
  def process_input(command, task = "")
    if command == "a" || command == "list"
      display_list
    elsif command == "b" || command == "add"
      add_task(task)
    elsif command == "c" || command == "delete"
      remove_task(task)
    elsif command == "d" || command == "complete"
      complete_task(task)
    end
  end
 
end
 
Controller.new('todo_sample.csv').go!(ARGV)
