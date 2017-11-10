class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable
  has_many :orders

  has_many :comments


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
end
