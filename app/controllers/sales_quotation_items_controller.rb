class SalesQuotationItemsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :update]
  before_action :set_sales_quotation_item, only: [:update]
  before_action :authorize_user!, only: [:update]
  
  def index
    @sales_quotation_items = SalesQuotationItem.includes(sales_quotation: [:customer])
                                                .where(sales_quotation: { user_id: current_user.id })
    filter_sales_quotation_items
    @sales_quotation_items = @sales_quotation_items.order(created_at: :desc).page(params[:page]).per(20)
  end
  
  
  
  
  def update
    @sales_quotation_item.update(sales_quotation_item_params)
  
    redirect_to sales_quotation_items_path
  end

  def filtered
    @sales_quotation_items = SalesQuotationItem.all
    filter_sales_quotation_items
    render :index
  end
  

  private

  def set_sales_quotation_item
    @sales_quotation_item = SalesQuotationItem.find(params[:id])
  end

  def sales_quotation_item_params
   params.require(:sales_quotation_item).permit(:result_id)
  end
  

  def authorize_user!
    if @sales_quotation_item.sales_quotation.user != current_user
      redirect_to sales_quotation_items_path, alert: "権限がありません"
    end
  end
  

  def filter_sales_quotation_items
    if params[:customer_name].present?
      @sales_quotation_items = @sales_quotation_items.joins(sales_quotation: :customer).where("customers.customer_name LIKE ?", "%#{params[:customer_name]}%")
    end
    if params[:quotation_number].present?
      @sales_quotation_items = @sales_quotation_items.joins(:sales_quotation).where("sales_quotations.quotation_number = ?", params[:quotation_number])
    end
    if params[:category].present?
      @sales_quotation_items = @sales_quotation_items.joins(:category).where("categories.category_name LIKE ?", "%#{params[:category]}%")
    end
    if params[:item_name].present?
      @sales_quotation_items = @sales_quotation_items.where("item_name LIKE ?", "%#{params[:item_name]}%")
    end
  end
end
