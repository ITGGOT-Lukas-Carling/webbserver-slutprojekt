require_relative './module.rb'

class App < Sinatra::Base

	enable :sessions
	include TodoDB

	get ('/') do
		erb(:index)
	end

	get ('/register') do
		erb(:register)
	end



	post ('/register') do

		username = params[:username]
		password = params[:password]
		nickname = params[:nickname]

		if username != nil 
			if user_compare(username).empty? == true
				if params[:password]==params[:second_password]

					crypt_pass = BCrypt::Password.create(password)
					create_user(username, crypt_pass, nickname)
				end
			end
		else
				error = "Please register correctly!"
				redirect('/register')
		end
		redirect('/register')
	end

end           
