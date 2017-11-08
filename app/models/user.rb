class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :orders

  has_many :comments

  
  def active_order
    active_state = Status.all.find_by(status_type: 'active')
    if orders.find_by(status_id: Status.find_by(status_type: 'active').id )
    else      
      orders.create!(status: active_state)
    end
    return orders.find_by(status_id: Status.find_by(status_type: 'active').id )
  end
end
