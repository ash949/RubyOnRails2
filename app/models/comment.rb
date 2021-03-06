# comment model
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :body, presence: {
    message: ": Review's body is empty"
  }
  validates :product, presence: true
  validates :rating, numericality: {
    only_integer: true, message: ": You didn't rate the product"
  }
  validates :user, uniqueness: {
    scope: :product, message: ': You have already reviewed this product'
  }

  after_create_commit { BroadcastCommentJob.perform_later(self, product) }
  scope :rating_desc, -> { order(rating: :desc) }
  scope :rating_asc, -> { order(:rating) }
  scope :id_desc, -> { order(id: :desc) }
end
