require './config/environment'
require 'rack-flash'
class ApplicationController < Sinatra::Base


  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_secret"
    use Rack::Flash
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
      redirect '/form_error'
    elsif !Stylist.find_by(name: params[:name], email: params[:email]).nil?
      redirect '/name_error'
    else
      @stylist = Stylist.create(params)
      session[:stylist_id] = @stylist.id
      flash[:message] = "Successfully signed up!"
      redirect :'clients'
    end
  end

  get '/login' do
    if Helpers.is_logged_in?(session)
      @stylist = Helpers.current_user(session)
      redirect :'clients'
    else
      erb :'stylists/login'
    end
  end

  post '/login' do
    if params[:name].empty? || params[:password].empty?
      redirect '/form_error'
    end
    @stylist = Stylist.find_by(name: params[:name])
    if !@stylist.nil?
      session[:stylist_id] = @stylist.id
      redirect :'clients'
    else
      erb :'stylists/create_stylist'
    end
  end

  get '/logout' do
    session.clear
    redirect '/'
  end

  get '/form_error' do
    erb :'stylists/form_error'
  end

  get '/name_error' do
    erb :'stylists/name_error'
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

  get '/clients/:id' do
    if Helpers.is_logged_in?(session)
      @stylist = Helpers.current_user(session)
      @client = Client.find(params[:id])
      erb :'clients/show_client'
    else
      redirect :'/login'
    end
  end

  get '/clients/:id/edit' do
    if Helpers.is_logged_in?(session)
      @stylist = Helpers.current_user(session)
      @client = Client.find(params[:id])
      erb :'clients/edit_client'
    else
      redirect :'stylists/login'
    end
  end

    post '/clients/:id' do
      @client = Client.find(params[:id])
      if params[:name].empty?
        redirect :"clients/#{@client.id}/edit"
      else
        @client.update(name: params[:name])
        redirect :'clients'
      end
    end

    delete '/clients/:id/delete' do
    @client = Client.find(params[:id])
    if @client.stylist == Helpers.current_user(session)
      @client.destroy
    end
  end

end
