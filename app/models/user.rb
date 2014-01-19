# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'digest'
class User < ActiveRecord::Base
    attr_accessor :password

    attr_accessible :name, :email, :password, :password_confirmation

    validates :name, {:presence =>true ,
                   :uniqueness => true
                     }
    validates :password, :presence => true,
                         :confirmation => true,
                         :length => {:within => 5..60}
    before_save :encrypt_password

    def has_password?(pwd)
    	encrypted_password == encrypt(pwd)
    end

    def self.authenticate(email, pwd)
    	user = User.find_by_email(email)
    	return nil if user.nil?
    	return user if user.has_password?(pwd)
    end

private

	def encrypt_password
		self.salt = make_salt if new_record?
		self.encrypted_password = encrypt(self.password)
	end

	def encrypt(string)
		secure_hash("#{salt}--#{string}")
	end

	def make_salt
		secure_hash("#{Time.now.utc}--#{password}")
	end

	def secure_hash(string)
		Digest::SHA2.hexdigest(string)
	end
end
