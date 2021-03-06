require 'bundler/setup'
require 'sinatra'
require 'sinatra/activerecord'
require 'rack-flash'
require 'sinatra/reloader' if development?


 
configure(:development){set :database, "sqlite3:blog.sqlite3"}

set :sessions, true
use Rack::Flash, :sweep => true

require './models'


# helpers do 
# 	def user
# 		@user = User.where(username: params[:username]).first.username.to_s
# 	end
# end

include FileUtils::Verbose

get "/img-upload" do
    erb :img_upload
end

post "/img-upload" do
    tempfile = params[:file][:tempfile] 
    filename = params[:file][:filename] 
    cp(tempfile.path, "public/img/propfiles/#{filename}")
    'Yeaaup'
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

get "/Home" do
	erb :home, :layout => :main
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
		erb :user_2, :locals => {:user => @user}

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
		erb :user, :locals => { :user => @user }
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
	if (@message.save)
		redirect "/user/#{@user.username}"
		flash.now[:notice] = "Message has been posted"
	else
		flash.now[:alert] = "Problem! "
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
	@user = User.where(id: session[:user_id]).first
	erb :user_2, :locals => {:user => @user}
end