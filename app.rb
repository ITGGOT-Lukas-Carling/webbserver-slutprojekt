require_relative './module.rb'

class App < Sinatra::Base

	enable :sessions
	include TodoDB

	get ('/') do
		erb(:index)
	end

end           
