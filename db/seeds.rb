# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

period = 6.months.ago

# Plan
invitation_reward_id = Plan.create(name: 'Invitation Reward', slug: PlanService::INVITATION_PLAN).id

# Users
users = (1..2000).map do |i|
  {
      username: "username#{i}",
      email: "email#{i}@example.com",
      domain: Faker::Number.between(1, 10) > 8 ? "domain#{i}.com" : nil,
      encrypted_password: 'password',
      completeness: (rand * 10).round(1),
      plan_id: (rand * 3).round == 3 ? invitation_reward_id : nil,
      created_at: Faker::Date.between(period, Date.today)
  }
end

User.import users, validate: false

# Projects
projects = (1..30000).map do |i|
  {
      title: "Project #{i}",
      user_id: (1999 * rand).round + 1,
      created_at: Faker::Date.between(period, Date.today)
  }
end

Project.import projects, validate: false

# Invitations
invitations = (1..100).map do |i|
  {
      inviter_id: (1999 * rand).round + 1,
      invitee: "username#{i}",
      created_at: Faker::Date.between(period, Date.today)
  }
end

Invitation.import invitations, validate: false
