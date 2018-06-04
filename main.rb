require 'sinatra'
require 'sinatra/reloader'
require 'sass'
require './students.rb'
require './comments.rb'
require 'dm-timestamps'

# for session management
configure do
	enable :sessions
	set :username, "krishna"
	set :password, "password"
end

helpers do # helper method to check for admin all the time
	def isStarted?
		session[:isStarted]
	end
end

get('/styles.css'){ scss :styles }

get '/' do
	@title="Home"
	erb :home
end

get '/about' do
	@title="About us"
	erb :about
end

get '/contact' do
	@title="Contact us"
	erb :contact
end

get '/login' do
	erb :login
end

post '/login' do
	if params[:username]==settings.username && params[:password]==settings.password
		session[:isStarted]=true
		erb :home
	else
		erb :login
		meesage="Password is invalid"
	end
end

get '/logout' do
	session[:isStarted]=false
	session.clear
	redirect to ('/')
end

not_found do
	erb :not_found
end

get '/video' do
	erb	:video
end
