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


	if @user.password == params[:password]
		session[:user_id] = @user.id
		flash[:notice] = "User signed in successfully."
		erb :user,:locals => {:user_id => @user_id}
	else
		erb :home, :layout => :main
		flash[:alert] = "Incorrect Password" #ERROR: loading this flash alert on a blank page, omits the layout.rb for some reason.

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
	erb :new_user_form
end

post '/sign-up' do
	new_user = User.new(params)
	if(new_user.save)
		erb :user, :locals => {:user => new_user}
	else
		#
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



