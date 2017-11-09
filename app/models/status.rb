class Status < ApplicationRecord
  has_many :orders

  def self.delivered
    find_by(status_type: 'delivered')
  end

  def self.canceled
    find_by(status_type: 'canceled')
  end

  def self.active
    find_by(status_type: 'active')
  end
end