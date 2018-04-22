class ClientController < ApplicationController

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
      redirect '/new_client_error'
    else
      @client = Client.create(name: params[:name], stylist_id: session[:stylist_id])
      redirect :'clients'
    end
  end

  get '/new_client_error' do
    erb :'/clients/new_client_error'
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
      redirect :'clients'
    end
  end

end
