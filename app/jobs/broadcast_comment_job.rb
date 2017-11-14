class BroadcastCommentJob < ApplicationJob
  queue_as :default

  def perform(comment)
    ProductChannel.broadcast_to comment.product.id, 
    comment_id: comment.id,
    commentator_id: comment.user.id,
    commentator_name: comment.user.full_name,
    product_name: comment.product.name,
    product_highest_rating_comment_id: comment.product.highest_rating_comment.id,
    product_lowest_rating_comment_id: comment.product.lowest_rating_comment.id,
    product_rating: comment.product.compute_average
  end
end
