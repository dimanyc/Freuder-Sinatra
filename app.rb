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
	@user_max = User.ids.max
	@user_range = (0..@user_max)

		if @user && @user.password == params[:password]
		session[:user_id] = @user.id
		flash[:notice] = "User signed in successfully."
		erb :user,:locals => {:user_id => @user_id}
		else

		
		flash.now[:alert] = "Incorrect Username or Password." 
		erb :home, :layout => :main
		#ERROR: loading this flash alert on a blank page, omits the layout.rb for some reason.
	#yield?
	#elsif @user.username.where([username == params[:username]]) <=> params[:username] 
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
		erb :user, :locals => {:user => @new_user}
	else
		flash.now[:notice] = "Thanks for registering. Grandpa Sig is excited to see you!" 
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



