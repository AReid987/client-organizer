require './config/environment'

use Rack::MethodOverride

use StylistsController
use ClientController
run ApplicationController
