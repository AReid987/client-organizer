require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "password_secret"
  end

  get '/signup' do
    if Helpers.is_logged_in?(session)
      @user = Helpers.current_user(session)
      redirect :'tweets'
    else
      erb :'users/create_stylist'
    end
  end

end
