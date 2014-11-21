class User < ActiveRecord::Base
  rolify
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :lockable
end
