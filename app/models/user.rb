# user model
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable
  has_many :orders
  has_many :comments

  after_save :send_welcome_email

  def full_name
    first_name + ' ' + last_name
  end

  def product_review(product_id)
    comments.find_by(product_id: product_id)
  end

  def active_order
    order = orders.active.take
    order = orders.create!(status: Status.active) unless orders.active.exists?
    order
  end

  private

  def send_welcome_email
    UserMailer.welcome(full_name, email).deliver_now if confirmed_at_changed?
  end
end
