require 'bundler/setup'
require 'sinatra'

configure(:development){set :database, "sqlite3:blog.sqlite3"}
require 'sinatra/reloader' if development?
require 'sinatra/contrib'
require 'sinatra/activerecord'
require 'rack-flash'



 

set :sessions, true
use Rack::Flash, :sweep => true

require './models'

include FileUtils::Verbose



# get '/', '/Home','/home','/index' do 
# 	if(session[:user_id])
# 		@user = User.where(id: session[:user_id]).first
# 		flash[:notice] = "Welcome back, #{@user.fname}!"
# 		redirect "user/:username"
		
# 	else
# 		erb :home, :layout => :main
# 	end
# end

# post '/', '/Home','/home','/index' do 
# 	@user = User.where(username: params[:username]).first
		
# 		if @user.username == params[:username] && @user.password == params[:password]
# 	 		session[:user_id] = @user.id
# 	 		flash[:notice] = "Grandpa Sigmnud is excited to see you, #{@user.fname}"
# 	 		#redirect "user/:username", :locals => { :user => @user }
# 	 		redirect "user/#{@user.username}", :locals => { :user => @user }
# 	 	else
# 	 		flash[:alert] = "Incorrect Username or Password." 
# 	  		erb :home, :layout => :main
#  		end
# end

# get "user/#{@user.username}" do |username|
# 	@user = User.find(id: session[:user_id]).first
# 	username = @user.username
	

# 	if (session[:user_id])
# 		flash[:notice] = "Grandpa Sigmnud is excited to see you, #{@user.fname}"	
# 		#@user = User.where(id: session[:user_id]).first
# 		erb :user, :locals => {:user => @user}
# 	else
# 		redirect '/'
# 		flash[:alert] = "Wrong email / password combination"
# 	end

# end





# get '/logout' do
# 	session.clear
# 	redirect '/'
# end


#### second version ends here

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



get '/', '/Home','/home','/index' do 
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

post '/', '/Home','/home','/index' do 
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
		@all_posts = Message.all.ids 
		@followers = User.find(@user.id).followee 
		@user_posts = User.find(session[:user_id]).messages  
		erb :user_3, :locals => {:user => @user, :all_posts => @all_posts, :followers => @followers, :user_posts => @user_posts}

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
		erb :user_2, :locals => { :user => @user }
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