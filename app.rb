require_relative './module.rb'

class App < Sinatra::Base
	set :default_encoding, 'utf-8'
	log_username = ""
	log_error= ""
	enable :sessions
	set :server, 'thin'
	set :sockets, []
	include TodoDB

	get ('/') do
		erb(:index)
	end

	get ('/register') do
		erb(:register)
	end


	get('/login') do
		erb(:login)
	end

	post('/login') do
		log_username = params["log-username"]
		log_password = params["log-password"]
		
		password = find_password_for_user(log_username)


		if password[0] == nil
			log_error = "Wrong username or password"
			redirect('/login')
		else
			password_digest = BCrypt::Password.new(password[0][0])
			if  password_digest == log_password
				session[:logged] = true
				session[:username] = log_username
				session[:online] = true
				log_error = ""
			else
				log_error = "Wrong username or password"
				redirect('/login')
			end
		redirect('/')
		end
	end

	post('/register') do

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

	get('/search/?') do
	end

	get('/search/:username') do
		username = params[:username].encode("UTF-8")
		userinformation = user_compare(username)
		erb(:search, locals:{userinformation:userinformation[0]})
	end

	
	get('/chat') do
		if session[:username].to_s==""
			redirect('/login')
		else
			username = session[:username].to_s
		end
		if !request.websocket?
		  erb(:chat)
		else
		  request.websocket do |ws|
			ws.onopen do
			  ws.send("Welcome to customer live support! My name is Adin, how can i help you #{session[:username]}?")
			  settings.sockets << ws
			end
			ws.onmessage do |msg|
			  send = session[:username].to_s + ": " + msg
			  EM.next_tick { settings.sockets.each{|s| s.send(send) } }
			end
			ws.onclose do
			  warn("websocket closed")
			  settings.sockets.delete(ws)
			end
		  end
		end
	end


end           

