# comments controller
class CommentsController < ApplicationController
  before_action :set_comment, only: %i[show destroy]
  before_action :authenticate_user!

  def show
    render partial: 'products/comment', locals: {
      comment: @comment, user: current_user
    }
  end

  def destroy
    authorize! :destroy, @comment
    @comment.destroy
    @product = @comment.product
    redirect_to @product, notice: 'Comment has been destroyed successfully'
  end

  def create
    set_product
    @comment = @product.comments.new(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        handle_create_comment_success(format, @comment)
      else
        handle_create_comment_errors(format, @comment)
      end
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :rating)
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def set_product
    @product = Product.find(params[:product_id])
  end

  def handle_create_comment_errors(format, comment)
    format.html do
      redirect_to comment.product,
                  flash: {
                    error: comment.errors.full_messages,
                    model: 'review'
                  }
    end
    format.json do
      render json: comment.errors, status: :unprocessable_entity
    end
  end

  def handle_create_comment_success(format, comment)
    notice_message = 'Your review has been submitted successfully'
    format.html { redirect_to comment.product, notice: notice_message }
    format.json { render :show, status: :created, location: comment.product }
    format.js
  end
end
