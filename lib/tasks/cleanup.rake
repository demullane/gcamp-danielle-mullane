task :cleanup => :environment do

  #clean memberships
  Membership.all.each do |membership|
    if membership.user == nil || membership.project == nil
      membership.destroy
    end
  end

  #clean tasks
  Task.all.each do |task|
    if task.project == nil
      task.destroy
    end
  end

  #clean comments
  Comment.all.each do |comment|
    if comment.task == nil
      comment.destroy
    end
  end

  #set comment user_id to nil if you user has been deleted
  Comment.all.each do |comment|
    if comment.user == nil
      comment.user = nil
      comment.save
    end
  end

end
