# broadcasting new comment job
class BroadcastCommentJob < ApplicationJob
  queue_as :default

  def perform(comment, product)
    ProductChannel.broadcast_to comment.product.id,
                                comment_id: comment.id,
                                commentator_id: comment.user.id,
                                commentator_name: comment.user.full_name,
                                product_name: comment.product.name,
                                highest_rating_comment_id:
                                  product.highest_rating_comment.id,
                                lowest_rating_comment_id:
                                  product.lowest_rating_comment.id,
                                product_rating: product.compute_average
  end
end
