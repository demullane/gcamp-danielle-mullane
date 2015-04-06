class AboutController < ApplicationController
  def index
    counter_hash = {}
    counter_hash["project"] = Project.all.count
    counter_hash["user"] = User.all.count
    counter_hash["task"] = Task.all.count
    counter_hash["membership"] = Membership.all.count

    counter_hash.each do |key, total|
      if total == 1
        if key == "membership"
          counter_hash[key] = "1 Project " + key.capitalize
        else
          counter_hash[key] = "1 " + key.capitalize
        end
      else
        if key == "membership"
          counter_hash[key] = total.to_s + " Project " + key.capitalize + "s"
        else
          counter_hash[key] = total.to_s + " " + key.capitalize + "s"
        end
      end
    end
    @project_count = counter_hash.values[0]
    @user_count = counter_hash.values[1]
    @task_count = counter_hash.values[2]
    @membership_count = counter_hash.values[3]
  end
end
