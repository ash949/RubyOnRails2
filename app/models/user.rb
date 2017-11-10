class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable
  has_many :orders

  has_many :comments

  after_save :send_welcome_email


  def full_name
    first_name + ' ' + last_name
  end
  
  def active_order
    order = orders.active.take
    unless orders.active.exists?
      order = orders.create!(status: Status.active)
    end
    return order
  end

  def after_save(user)            
    if user.confirmed_at_changed?
      UserMailer.welcome(user.full_name, user.email).deliver_now
    end
  end

  private
  def send_welcome_email
    if self.confirmed?
      UserMailer.welcome(full_name, email).deliver_now
    end
  end
end
