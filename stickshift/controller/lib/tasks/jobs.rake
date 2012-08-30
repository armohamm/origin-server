namespace :jobs do
  desc "TODO"
  task :run => :environment do
    require 'pry'
    binding.pry
  end
end
