class Stylist < ActiveRecord::Base
  has_secure_password 
  has_many :clients
end
