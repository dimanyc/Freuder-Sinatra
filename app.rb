require 'bundler/setup'
require 'sinatra'

require 'sinatra/reloader' if development?
require 'sinatra/activerecord'
require 'rack-flash'

#require 'sinatra/contrib'


configure(:development){set :database, "sqlite3:blog.sqlite3"}


set :sessions, true
use Rack::Flash, :sweep => true

require './models'

#, '/Home','/home','/index'


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
		erb :user_3, :locals => {:user => @user, :all_posts => @all_posts, :followers => @followers,:followed => @followed ,:user_posts => @user_posts}

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
		erb :user_2, :locals => { :user => @user }
		flash.now[:notice] = "Thanks for registering. Grandpa Sig is excited to see you!"
		redirect "/user/#{@user.username}"
	else
		flash.now[:alert] = "Something is not right. Double-check everything" 
	end

end

get '*/posts' do 
	erb :user_posts 
end

post '/post-new-slip' do
	@message = Message.new(params)
	@user = User.find(session[:user_id])
	@message.user_id = @user.id

	if (@message.save)
		erb :user_3, :locals => { :user => @user }
		flash.now[:notice] = "Message has been posted"
		redirect "/user/#{@user.username}"

	else
		flash.now[:alert] = "Problem! "
		erb :user_2, :locals => { :user => @user }
	end

end


get '/logout' do 
	session.clear 
	redirect '/'
end

get '/Feed' do
	erb :feed
end

get '/test' do
	erb :user_3, :locals => { :user => @user }
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
		flash[:notice] = "Welcome back, #{@user.fname}!"
		erb :user, :locals => { :user => @user }
		redirect "/user/#{@user.username}"	
		
	else
		erb :home, :layout => :main
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