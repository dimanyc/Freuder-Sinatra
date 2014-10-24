require 'bundler/setup'
require 'sinatra'
require 'sinatra/activerecord'
require 'rack-flash'
 
set :database, "sqlite3:app.sqlite3"
set :sessions, true
use Rack::Flash, :sweep => true

require './models'


get '/' do 

	erb :home, :layout => :main
end


post '/' do

	@user = User.where(username: params[:username]).first

		if @user && @user.password == params[:password]
		session[:user_id] = @user.id
		flash[:notice] = "User signed in successfully."
		erb :user,:locals => {:user => @user}
		else

		
		flash[:alert] = "Incorrect Username or Password." 
		erb :home, :layout => :main

	end	
end

get '/home' do 

	erb :home, :layout => :main
end


post '/home' do 
	erb :home, :layout => :main
end

get '/user' do
	erb :user 
end


get '/sign-up' do
	erb :new_user_form, :layout => :main
end

post '/sign-up' do
	new_user = User.new(params)
	@user = User.where(username: params[:username]).first
	if(new_user.save)
		flash.now[:notice] = "Thanks for registering. Grandpa Sig is excited to see you!"
		erb :user, :locals => {:user => @new_user}
	else
		flash.now[:alert] = "Something is not right. Double-check everything" 
		erb :home, :layout => :main	
	end

end

get '/sign-in' do
  erb :sign_in
end

post '/sign-in' do
	user = User.where(username: params[:username]).first
	if user.password == params[:password]
		flash[:notice] = "User signed in successfully."
		redirect '/user'
	elsif 
		user.password <=> params[:password]
		flash[:alert] = "There was a problem signing you in."
	else
		flash[:alert] = "There was a problem signing you in."
		redirect '/'
	end
end



