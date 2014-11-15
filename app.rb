require 'bundler/setup'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'sinatra/activerecord'
require 'rack-flash'
require 'dragonfly'


configure(:development){set :database, "sqlite3:blog.sqlite3"}


set :sessions, true
use Rack::Flash, :sweep => true

require './models'

def current_user 
	@current_user ||= User.find(session[:user_id])
end


get '/' do 
	if (session[:user_id])
		@user = User.where(id: session[:user_id]).first
		flash[:notice] = "Welcome back, #{@user.fname}!"
		erb :user, :locals => { :user => @user }
		redirect "/user/#{@user.username}"	
		
	else
		erb :home, :layout => :main
	end
end

post '/' do 
	@user = User.where(username: params[:username]).first
	if @user && @user.password == params[:password]
		session[:user_id] = @user.id
		flash[:notice] = "User signed in successfully."
		erb :user, :locals => { :user => @user }
		redirect "/user/#{@user.username}"
	else 
		flash[:alert] = "Incorrect Username or Password." 
 		erb :home, :layout => :main
	end
end

get "/user/*" do
	if (session[:user_id])
		@user = User.where(id: session[:user_id]).first
		@user_posts = User.find(session[:user_id]).messages 
		@all_posts = Message.all.ids 
		@followers = User.find(@user.id).followers
		@followed = User.find(@user.id).followed
		erb :user_4,:locals => { :user => @user }, :locals => { :all_popst => @all_posts }, :locals => { :followers => @followers }, :locals => { :followed => @followed }, :locals => { :user_author => @user_author } 

	else
		redirect '/'
		
	end
end


get '/sign-up' do 
	erb :sign_up, :layout => :main
end

post '/sign-up' do
	session.clear
	@user = User.new(params)
	if(@user.save)
		session[:user_id] = @user.id
		erb :user_4, :locals => { :user => @user }
		flash.now[:notice] = "Thanks for registering. Grandpa Sig is excited to see you!"
		redirect "/user/#{@user.username}"
	else
		flash.now[:alert] = "Something is not right. Double-check everything" 
	end

end

get '*/Posts' do 
	erb :feed 
end

post '/post-new-slip' do
	@message = Message.new(params)
	@user = User.find(session[:user_id])
	@message.user_id = @user.id

	if (@message.save)
		erb :user_4, :locals => { :user => @user }
		flash.now[:notice] = "Message has been posted"
		redirect "/user/#{@user.username}"

	else
		flash.now[:alert] = "Problem! "
		erb :user_4, :locals => { :user => @user }
	end

end



get "/users/:id/follow" do
  user = User.find(params[:id])
  current_user.follow!(user) if user
  flash[:notice] = "User followed successfully."
  redirect "/"
end

get '/index' do 
	if (session[:user_id])
		@user = User.where(id: session[:user_id]).first
		@all_posts = Message.all.ids 
		@followers = User.find(@user.id).followers
		@followed = User.find(@user.id).followed
		@user_author = User.find(Message.find(n).user_id)
		flash[:notice] = "Welcome back, #{@user.fname}!"
		erb :user,:layout => :layout_v2, :locals => { :user => @user }, :locals => { :all_popst => @all_posts }, :locals => { :followers => @followers }, :locals => { :followed => @followed }, :locals => { :user_author => @user_author } 
		redirect "/user/#{@user.username}"	
		
	else
		erb :home, :layout => :layout_v2
	end
end

get '/home' do 
	if (session[:user_id])
		@user = User.where(id: session[:user_id]).first
		flash[:notice] = "Welcome back, #{@user.fname}!"
		erb :user, :locals => { :user => @user }
		redirect "/user/#{@user.username}"	
		
	else
		erb :home, :layout => :main
	end
end

get '/Home' do 
	if (session[:user_id])
		@user = User.where(id: session[:user_id]).first
		flash[:notice] = "Welcome back, #{@user.fname}!"
		erb :user, :locals => { :user => @user }
		redirect "/user/#{@user.username}"	
		
	else
		erb :home, :layout => :main
	end
end

post '/index' do 
	@user = User.where(username: params[:username]).first
	if @user && @user.password == params[:password]
		session[:user_id] = @user.id
		flash[:notice] = "User signed in successfully."
		erb :user, :locals => { :user => @user }
		redirect "/user/#{@user.username}"
	else 
		flash[:alert] = "Incorrect Username or Password." 
 		erb :home, :layout => :main
	end
end

post '/home' do 
	@user = User.where(username: params[:username]).first
	if @user && @user.password == params[:password]
		session[:user_id] = @user.id
		flash[:notice] = "User signed in successfully."
		erb :user, :locals => { :user => @user }
		redirect "/user/#{@user.username}"
	else 
		flash[:alert] = "Incorrect Username or Password." 
 		erb :home, :layout => :main
	end
end

post '/Home' do 
	@user = User.where(username: params[:username]).first
	if @user && @user.password == params[:password]
		session[:user_id] = @user.id
		flash[:notice] = "User signed in successfully."
		erb :user, :locals => { :user => @user }
		redirect "/user/#{@user.username}"
	else 
		flash[:alert] = "Incorrect Username or Password." 
 		erb :home, :layout => :main
	end
end

#profile image upload
get '/save-profile-image' do
	redirect '/home'
end

post '/save-profile-image' do
	@user = User.find(session[:user_id])
	@filename = @user.username
	# File.open('uploads/' + params['myfile'][:filename], "wb") do |f|

	File.open('uploads/' + @filename, "wb") do |f|
    #f.write(@filename[:tempfile].read)
    f.write(params['myfile'][:tempfile].read)

  end
  flash[:notice] = "The file was successfully uploaded!"

	erb :user_4
end


get '/logout' do 
	session.clear 
	redirect '/'
end

get '/Feed' do
	erb :feed
end

get '/test' do
	erb :user_4, :layout => :main, :locals => { :user => @user }
end