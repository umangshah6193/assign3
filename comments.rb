require 'sinatra'
require 'sinatra/reloader'
require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/students.db")
DataMapper.finalize
DataMapper.auto_upgrade!

class Comment
	include DataMapper::Resource
	property :cid, Serial
	property :comment, String
	property :name, String
	property :created_at, Time
end

get '/comments' do
	@comments=Comment.all
	erb :comments
end

get '/comments/new' do
	@comment=Comment.new
	erb :add_comments
end

get '/comments/:cid' do
	@comment = Comment.get(params[:cid])
	erb :view_comment
end

delete '/comments/:cid' do
	if session[:isStarted]==true
  		Comment.get(params[:cid]).destroy
		redirect to('/comments')
	else
		redirect to('/login')
	end		
end

post '/comments' do  
	comment = Comment.create(params[:comment])
	comment.save
	redirect to("/comments/#{comment.cid}")
  end

get '/comments/:cid/viewdetails' do
	@comment=Comment.get(params[:cid])
	erb :view_comment
end
