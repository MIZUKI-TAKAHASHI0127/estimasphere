class CommentsController < ApplicationController
  before_action :set_comment, only: [:edit, :update]
  before_action :check_authorization, only: [:edit, :update]


  def create
    @commentable = find_commentable
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
  
    if @comment.save
      redirect_to @commentable
    else
      render :new
    end
  end

  def show
    @comment = Comment.new
    @comments = @commentable.comments.includes(:user)
  end

  def edit
  end
  
  def update 
    if @comment.update(comment_params)
      redirect_to @comment.commentable
    else
      render :edit
    end
  end
  
  private
  
  def set_comment
    @comment = Comment.find(params[:id])
    @commentable = @comment.commentable
    
  end
  
  def check_authorization
    unless @comment.user == current_user
      redirect_to @comment.commentable, alert: "You're not authorized to edit this comment."
    end
  end

  def comment_params
    params.require(:comment).permit(:text).merge(user_id: current_user.id)
  end

  def find_commentable
    if params[:sales_quotation_id]
      SalesQuotation.find(params[:sales_quotation_id])
    elsif params[:purchase_quotation_id]
      PurchaseQuotation.find(params[:purchase_quotation_id])
    else
      raise "Unknown commentable type"
    end
  end
end
