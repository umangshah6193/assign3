require 'sinatra'
require 'sinatra/reloader'
require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/students.db")

class Student
	include DataMapper::Resource
	property :sid, Serial
	property :fname, String
	
	property :lname, String
	property :address, String
	property :dob, String
end

DataMapper.finalize
DataMapper.auto_upgrade!

get '/students' do
	@students=Student.all
	erb :students
end

get '/students/new' do
	if session[:isStarted]==true
		@student=Student.new
		erb :add_student
	else
		redirect to('/login')
	end
end

get '/students/:sid' do
	@student = Student.get(params[:sid])
	erb :display_student
end

post '/students' do  
  student = Student.create(params[:stud])
  student.save
  redirect to("/students/#{student.sid}")
end

post '/students/:sid' do
	student=Student.get(params[:sid])
	student.update(params[:stud])
	redirect to("/students/#{student.sid}")
end

delete '/students/:sid' do
  Student.get(params[:sid]).destroy
  redirect to('/students')
end

get '/students/:sid/edit' do
  @student = Student.get(params[:sid])
  erb :edit_student
end

