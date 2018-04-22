require './config/environment'

use Rack::MethodOverride

use StylistsController
run ApplicationController
