require 'bundler/setup'
require 'sinatra'
require 'sinatra/activerecord'
require 'rack-flash'
 
set :database, "sqlite3:app.sqlite3"
set :sessions, true
use Rack::Flash, :sweep => true

require './models'

helpers do
  def current_user
		@user = User.where(username: params[:username]).first
  end
end


get '/' do 
	erb :home, :layout => :main
end

post '/' do 
	
	if @user && @user.password == params[:password]
		session[:user_id] = @user.id
		flash[:notice] = "User signed in successfully."
		redirect '/user' + @current_user

	else 
		flash[:alert] = "Incorrect Username or Password." 
 		erb :home
	end

end

get '/user' + @user
	erb :user
end


# get '/' do 

# 	erb :home, :layout => :main
# end

# ### Install Pony for email sending. -> http://www.sinatrarb.com/faq.html#multiroute
# post '/' do

# 	@user = User.where(username: params[:username]).first
	

# 		if @user && @user.password == params[:password]
# 		session[:user_id] = @user.id
# 		session[:username] = @user.username
# 		flash[:notice] = "User signed in successfully."

# 		username = User.where(username: params[:username]).first.username.to_s
# 		redirect '/user/:username' 
# 		#redirect '/user/:username' + username.to_s 
# 		else

		
# 		flash[:alert] = "Incorrect Username or Password." 
# 		erb :home, :layout => :main 

# 	end	
# end


# get '/home' do 

# 	erb :home, :layout => :main
# end


# post '/home' do 
# 	erb :home, :layout => :main
# end

# get '/user/:username' do
# 	@user = params.values_at('username')
# 	erb :user,:locals => {:user => User.where(username: session[:username]).first}
	
# end


# # get '/user/' + username.to_s  do
# # 	@username = User.where(username: session[:username]).first.username.to_s
# # 	erb :user ,:locals => {:user => User.where(username: session[:username]).first}
# # end
# get '/user_test' do
	
# end


# get '/sign-up' do
# 	erb :new_user_form, :layout => :main
# end

# post '/sign-up' do
# 	new_user = User.new(params)
# 	user = User.where(username: params[:username]).first
# 	if(new_user.save)
# 		flash.now[:notice] = "Thanks for registering. Grandpa Sig is excited to see you!"
# 		erb :user, :locals => {:user => @new_user}
# 	else
# 		flash.now[:alert] = "Something is not right. Double-check everything" 
# 		#erb :home, :layout => :main	
# 	end

# end

# get '/sign-in' do
#   erb :sign_in
# end

# post '/sign-in' do
# 	user = User.where(username: params[:username]).first
# 	if user.password == params[:password]
# 		flash[:notice] = "User signed in successfully."
# 		redirect '/user'
# 	elsif 
# 		user.password <=> params[:password]
# 		flash[:alert] = "There was a problem signing you in."
# 	else
# 		flash[:alert] = "There was a problem signing you in."
# 		redirect '/'
# 	end
# end



