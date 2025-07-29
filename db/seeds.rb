# This file should contain all the record creation needed to seed the database with its default values.
Micropost.create(content: "Hello, world!")
Micropost.create(content: "My second post.")
Micropost.create(content: "Ruby on Rails is awesome!")

User.create!(
  name: "Example User",
  email: "example@railstutorial.org",
  gender: 2,
  date_of_birth: Date.new(1990, 1, 1),
  password: "Abcd123@",
  password_confirmation: "Abcd123@",
  admin: true,
  activated: true, activated_at: Time.zone.now
)

30.times do |i|
  name = Faker::Name.name
  email = "example-#{i + 1}@railstutorial.org"
  gender = rand(0..2)
  dob = Faker::Date.birthday(min_age: 18, max_age: 65)
  password = "Abcd123@"

  User.create!(
    name: name,
    email: email,
    gender: gender,
    date_of_birth: dob,
    password: password,
    password_confirmation: password,
    activated: true, activated_at: Time.zone.now
  )
end

users = User.order(:created_at).take(6)
30.times do
 content = Faker::Lorem.sentence(word_count: 5)
 users.each { |user| user.microposts.create!(content: content) }
end

users = User.all
user = users.first
following = users[2..20]
followers = users[3..15]
following.each{|followed|
user.follow(followed)}
followers.each{|follower|
follower.follow(user)}
