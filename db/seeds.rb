# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#CREATE SOME ADMINS
p '======================================'
p 'ADMINS'
p '======================================'
Admin.new(first_name: 'Anakin', last_name: 'Skywalker', title: 'Jedi Knight', email: 'anakin@pxp200.com', password: '1asdf2', password_confirmation: '1asdf2', status: 'active').save
Admin.new(first_name: 'Leia', last_name: 'Organa', title: 'Rebel Leader', email: 'leia@pxp200.com', password: '1asdf2', password_confirmation: '1asdf2', status: 'active').save
Admin.new(first_name: 'Kylo', last_name: 'Ren', title: 'Sith', email: 'kylo@pxp200.com', password: '1asdf2', password_confirmation: '1asdf2', status: 'active').save
Admin.new(first_name: 'Han', last_name: 'Solo', title: 'Smugler', email: 'han@pxp200.com', password: '1asdf2', password_confirmation: '1asdf2', status: 'active').save
Admin.new(first_name: 'Boba', last_name: 'Fett', title: 'Bounty Hunter', email: 'boba@pxp200.com', password: '1asdf2', password_confirmation: '1asdf2', status: 'active').save


#CREATE SOME DEPARTMENTS
p "======================================"
p "DEPARTMENTS"
p "======================================"
departments = ["Administrative Services", "Cemetery", "Landfill", "Parks", "Planning & Zoning", "Police", "Power", "Utilities", "Water"]
departments.each do |dept|
  admin = Admin.order("RAND()").limit(1)
  params = {}
  params["name"] = dept
  params["admin_id"] = admin[0].id
  params["body"] = Faker::Lorem.paragraph(5)
  department = Department.new(params)
  department.save
  p dept
end


# CREATE SOME EVENTS
p '======================================'
p 'EVENTS'
p '======================================'
60.times do
  admin = Admin.order('RAND()').limit(1)
  params = {}
  params['title'] = Faker::Company.buzzword
  params['description'] = Faker::Company.catch_phrase
  params['start_time'] = Faker::Time.between(30.days.ago, Date.today)
  # Set end time anywhere from one hour to 3 days after start
  params['end_time'] = params['start_time'] + Faker::Number.between(60*60, 60*60*24*3)
  params['admin_id'] = admin[0].id
  params['status'] = %w[active inactive][rand(2)]
  event = Event.new(params)
  event.save
  p event.title
end


#CREATE SOME USERS
p '======================================'
p 'USERS'
p '======================================'
100.times do
  params = {}
  params['first_name'] = Faker::Name.first_name
  params['last_name'] = Faker::Name.last_name
  params['email'] = Faker::Internet.email(params['first_name'])
  params['password'] = '1asdf2'
  params['password_confirmation'] = '1asdf2'
  user = User.new(params)
  user.save
  p user.name
end


#CREATE CITIZEN REQUESTS
p '======================================'
p 'CITIZEN REQUEST'
p '======================================'
50.times do
  user = User.order('RAND()').limit(1)
  department = Department.order('RAND()').limit(1)
  params = {}
  params['user_id'] = user[0].id
  params['department_id'] = department[0].id
  params['title'] = Faker::Color.color_name
  params['request'] = Faker::Lorem.sentence(3)
  request = CitizenRequest.new(params)
  request.save
  p request.title
end


#SET UP GALLERY CATEGORIES
p '======================================'
p 'GALLEY CATEGORY'
p '======================================'
10.times do
  admin = Admin.order('RAND()').limit(1)
  params = {}
  params['title'] = Faker::App.name
  params['description'] = Faker::ChuckNorris.fact
  params['admin_id'] = admin[0].id
  gallery = GalleryCategory.new(params)
  gallery.save
  p gallery.title
end


#ADD SOME GALLERY ITEMS
p '======================================'
p 'GALLEY ITEMS'
p '======================================'
100.times do
  admin = Admin.order('RAND()').limit(1)
  #user.avatar = File.open((File.join(Rails.root, '/test/fixtures/bison.jpg))
  params = {}
  params['title'] =
  params['description'] =
  params['admin_id'] = admin[0].id
  #params['image'] = File.new('/test/fixtures/bison.jpg')
  params['image'] = File.open(File.join(Rails.root, '/test/fixtures/bison.jpg'))
  gallery = GalleryItem.new(params)
  gallery.save
  p gallery.title
end


#CREATE PAGE CATEGORIES
p "======================================"
p "PAGE CATEGORIES"
p "======================================"
25.times do
  admin = Admin.order("RAND()").limit(1)
  department = Department.order("RAND()").limit(1)
  params = {}
  params["title"] = Faker::Company.buzzword
  params["body"] = Faker::Lorem.paragraph(5)
  params["admin_id"] = admin[0].id
  params["department_id"] = department[0].id
  category = PageCategory.new(params)
  category.save
  p category.title
end


#ADD SOME PAGES
p '======================================'
p 'PAGES'
p '======================================'
70.times do
  admin = Admin.order('RAND()').limit(1)
  category = PageCategory.order('RAND()').limit(1)
  params = {}
  params['title'] = Faker::Company.buzzword
  params['body'] = Faker::Lorem.paragraph(5)
  params['admin_id'] = admin[0].id
  params['page_category_id'] = category[0].id
  params['department_id'] = category[0].department_id
  page = Page.new(params)
  page.save
  p page.title
end

# CREATE SOME NEWS
p '======================================'
p 'NEWS'
p '======================================'
20.times do
  admin = Admin.order('RAND()').limit(1)
  params = {}
  params['title'] = Faker::Company.buzzword
  params['content'] = Faker::Company.catch_phrase
  params['admin_id'] = admin[0].id
  news = News.new(params)
  news.save
  p news.title
end

