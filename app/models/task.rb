
class Task < ActiveRecord::Base

  # def edit_task(title)
  #   title = title
  #   save
  # end

  def Task.edit(id, new_title)
    task = Task.find(id)
    task.title = new_title
    task.save
  end

  def Task.complete(id)
    task = Task.find(id)
    task.completed = 1
    task.completed_at = Time.now
    task.save
  end

  def Task.list
    
    Task.all.each do |x| 
      if x.completed
        c = "X"
      else
        c = " "
      end
      puts "#{x.id}. [#{c}] #{x.title}"
    end

  end
end




