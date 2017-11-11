class CommentsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    set_comment
    authorize! :destroy, @comment
    @comment.destroy
    @product = @comment.product
    redirect_to @product, notice: 'Comment has been destroyed successfully'
  end

  def create
    @product = Product.find(params[:product_id])
    @comment = @product.comments.new(comments_params)
    @comment.user = current_user
    

    respond_to do |format|
      if @comment.save
        format.html{ redirect_to @product, notice: 'Your review has been submitted successfully'} 
        format.json { render :show, status: :created, location: @product }
        format.js
      else
        format.html{ redirect_to @product, flash: { error: @comment.errors.full_messages, model: 'review' } } 
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end  
    end
  end


  private
    def comments_params
      params.require(:comment).permit(:body, :rating)
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end
end