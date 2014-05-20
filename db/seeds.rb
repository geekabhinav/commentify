# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Tag.destroy_all
tag = Tag.create!(name: 'General')

Comment.destroy_all
comments = ["Beautiful!", "Excellent shot.", "Excellent", "Excellente...", "Excellent Capture", "Excellent photo", "excellent photo.", "this is an excellent capture", "this is an excellent photo, well done", "this is beautiful", "beautiful shot", "this is beautiful, good job", "this is beautiful, great shot", "this is amazing, great shot", "great, this is amazing", "amazingly good shot", "great shot, amazing!", "great shot this is, well done", "excellent shot this is, well done", "excellent capture, good job! ", "excellent capture, great job! ", "great photo, good job", "great photo, excellent job", "amazing work, good job", "Love it, voted", "Great shot, voted", "Amazing photo, voted! great job", "I like this photo quite a bit, great job. ", "nice shot. ", "Very nice work", "Very nice shot, great job! ", "Very nice work, voted! ", "Aweseom!!", "Awesome, voted! ", "Beautiful! voted! ", "Excellent shot, Liked! ", "Excellent, voted", "Excellent Capture, voted! ", "Excellent photo, voted! keep it up!", "excellent composition! Love it! ", "this is an excellent capture, voted! keep it up ", "this is an excellent photo, well done. Voted!", "this is beautiful, voted!", "beautiful shot. voted!"]

comments.each do |comment|
  tag.comments.create!(body: comment.strip)
end
