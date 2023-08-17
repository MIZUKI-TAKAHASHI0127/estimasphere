class CategoriesController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  def index
    @categories = Category.all
  end

  def new
    @categories = Category.new
  end

  def create
    @categories = Category.create(category_params)
    if @categories.all?(&:valid?)
      redirect_to categories_path, notice: 'Categories were successfully created.'
    else
      render :new
    end
  end

  private

  def category_params
    params.require(:categories).map do |p|
      p.permit(:category_name)
    end
  end

end