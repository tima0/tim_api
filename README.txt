# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks
== README

This README contains the steps that are necessary to get the
Tim API up and running.

If you are starting a new project make sure that you remove the .git directory and create a new repo
for the new project that you are creating. 

Things you need to do:

* Ruby version

  <tt>ruby 2.3.1p112</tt>

* System dependencies

  <tt>bundle install</tt>

* Configuration
  
  Make a copy of database.yml.sample as database.yml and update the parameters to match your local database credentials.


* Database creation

  <tt>rake db:create</tt>

* Database initialization

  <tt>rake db:migrate</tt>

  <tt>rake db:seed</tt>

* How to run the test suite

  <tt>rake test</tt>

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


To generate the docs on your local build: <tt>rake doc:app</tt>.
