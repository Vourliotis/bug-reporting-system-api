# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Bug.delete_all
User.delete_all

user = User.create! email: 'admin@admin.com', password: 'admin', role: 3
puts "Created user: #{user.email}"
5.times do
  user = User.create! email: Faker::Internet.email, password: 'password', role: rand(0..2)
  puts "Created user: #{user.email}"
end

5.times do
  bug = Bug.create! title: Faker::Lorem.word, description: Faker::Lorem.sentence, priority: rand(0..2),
                    status: rand(0..2), comments: Faker::Lorem.sentence, user: User.order(Arel.sql('RANDOM()')).first
  puts "Created bug: #{bug.title}"
end
