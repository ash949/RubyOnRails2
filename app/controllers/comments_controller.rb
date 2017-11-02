class CommentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
  end

  def create
    @product = Product.find(params[:product_id])
    @comment = @product.comments.new(comments_params)
    @comment.user = current_user
    @comment.save
    redirect_to @product
  end


  private
    def comments_params
      params.require(:comment).permit(:body, :rating, :created_at)
    end
end