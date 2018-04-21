require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_secret"
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    if Helpers.is_logged_in?(session)
      @stylist = Helpers.current_user(session)
      redirect :'clients'
    else
      erb :'stylists/create_stylist'
    end
  end

  post '/signup' do
    if params[:name].empty? || params[:email].empty? || params[:password].empty?
      redirect '/signup'
    else
      @stylist = Stylist.create(params)
      session[:stylist_id] = @stylist.id
      redirect :'clients'
    end
  end

  get '/clients' do
    if Helpers.is_logged_in?(session)
      @stylist = Helpers.current_user(session)
      erb :'/clients/clients'
    else
      redirect '/login'
    end
  end

  post '/clients' do
    if params[:name].empty?
      redirect :'clients/new'
    else
      @client = Client.create(name: params[:name], stylist_id: session[:stylist_id])
      redirect :'clients'
    end
  end

  get '/clients/new' do
    if Helpers.is_logged_in?(session)
      @stylist = Helpers.current_user(session)
      erb :'/clients/create_client'
    end
  end
end
