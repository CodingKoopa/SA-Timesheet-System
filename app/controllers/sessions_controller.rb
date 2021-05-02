class SessionsController < ApplicationController
	 def nested_hash nh, indent
    puts indent + "VALUE is a nested hash"
    indent += '  '
    nh.each_pair do |key, value|
      puts indent + "KEY: #{key}"
      if value.kind_of?(Hash)
        nested_hash(value, indent)
      else
        puts indent + "VALUE:  #{value}"
      end     
    end
  end

  def start_test
  end

  def clear
  end

  def debug
		auth_hash = request.env['omniauth.auth']
    p auth_hash
  		    
    puts '\n raw auth_hash\n'
    p auth_hash
    puts '\n\nauth_hash by key\n'
    auth_hash.each_pair do |key, value|
    puts "\nKEY: #{key}"
    if value.kind_of?(Hash)
      nested_hash(value, '')
    else
      puts "Value: #{value}"
    end
    end
  end

  def new
  end

  def create
    begin
		  if Authorization.exists?(auth_hash)
        # indent code
# 				message = "Welcome back #{@user.name}! You have logged in via #{auth.provider}."
#         flash[:notice] = message
      
      else # immediately before your register code
        # indent code
#          message = "Welcome #{@user.name}! You have signed up via #{auth.provider}."
# 				 flash[:notice] = message
      end
		@user = User.create_with_omniauth(auth_hash['info'])
		
	  auth = Authorization.create_with_omniauth(auth_hash, @user)
		auth = Authorization.find_with_auth_hash(auth_hash)
	  @user = User.find_with_auth_hash(auth_hash['info'])
		session[:user_id] = auth.user.id 
		
		self.current_user= auth.user
		
		@profile = @user.create_profile
	  message = "Welcome #{@user.name}! You have signed up via #{auth.provider}."
    flash[:notice] = message
		
		redirect_to edit_user_profile_path(@user,@profile) 
	  #user = User.create!("name" => auth_hash[:info][:name], "email" => auth_hash[:info][:email])
		rescue ActiveRecord::RecordInvalid,  Exception => exception
			flash[:warning] = "#{exception.class}: #{exception.message}" 
      redirect_to timesheets_landing_path and return
		end
		
  end

  def failure
		
  end

  def destroy
  end
	
  private 
  def auth_hash
    #ensures that it's only retrieved once per cycle
    @auth_hash ||= request.env['omniauth.auth']
  end
end
