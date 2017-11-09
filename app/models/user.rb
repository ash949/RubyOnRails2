class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :orders

  has_many :comments


  def full_name
    first_name + ' ' + last_name
  end
  
  def active_order
    byebug
    order = orders.active.take
    unless orders.active.exists?
      order = orders.create!(status: Status.active)
    end
    return order
  end
end
