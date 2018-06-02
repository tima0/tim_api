class User < ActiveRecord::Base
  attr_accessor :password, :password_confirmation

  has_many :citizen_requests

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password_confirmation, presence: true, on: :create
  validates_confirmation_of :password, allow_blank: true
  validates :password, presence: true, format: {:with => /\A(?=.*[a-zA-Z]).{6,}\Z/ }, on: :create

  before_create :set_token
  before_save :encrypt_password

  def name
    "#{self.first_name} #{self.last_name}"
  end

  def set_token
    generate_token(:apikey)
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.hex
    end while User.exists?(column => self[column])
  end

  def encrypt_password
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)
    end
  end
end
