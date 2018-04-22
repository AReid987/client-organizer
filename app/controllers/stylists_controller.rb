class StylistsController < ApplicationController

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

end
