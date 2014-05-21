namespace :bot do
  desc 'Loop through all active users, do User.get_links'
  task run: :environment do
    puts "Running bot at #{Time.now.to_s}"
    active_users = User.where(:status => 'active').all
    puts "Found #{active_users.length.to_s} users with active state"
    active_users.each do |user|
      user.get_links
      puts "Pulled links for 500px user: #{user.username} and added to queue at #{Time.now.to_s}"
      sleep(10)
    end
  end
end