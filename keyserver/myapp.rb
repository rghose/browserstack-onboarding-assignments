require 'sinatra'
require './key.rb'
require 'logger'

$LOG = Logger.new(STDOUT)

class Myapp < Sinatra::Application

	def initialize
		super
		@data = UniqueKey.new
	end

	# Create a Key resource
	post '/key' do
		retval = @data.new
		return "Key generated #{retval}"
	end

	# get a Key
	get '/key' do
		not_found_string = "please generate a new key"
		v = @data.get_available
		if v.nil?
			status 404
			not_found_string 
		else
			if @data.block_key(v)
				v
			else
				status 404
				not_found_string 
			end
		end
	end

	# unblock a key
	put '/key' do
		id = params[:id]
		if not id.nil?
			if @data.unblock_key(id)
				"Unblocked"
			else
				status 404
				"Key not found"
			end
		else
			status 403
			"No key"
		end
	end

	# delete a key
	delete '/key' do
		id = params[:id]
		if id.nil?
			status 403
			"No Key"
		else
			if @data.delete_key(id)
				"Deleted"
			else
				status 404
				"Key not found"
			end
		end
	end

	get '/refresh' do
		id = params[:id]
		if id.nil?
			status 403
			"No Key"
		else
			if @data.update_time(id)
				"Updated"
			else
				status 404
				"Key not found"
			end
		end
	end
end

Myapp.run!
