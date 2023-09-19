class PurchaseQuotationItemsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :update]
  before_action :set_purchase_quotation_item, only: [:update]
  before_action :authorize_user!, only: [:update]
  
  def index
    @purchase_quotation_items = PurchaseQuotationItem.includes(purchase_quotation: [:customer])
                                                .where(purchase_quotation: { user_id: current_user.id })
    filter_purchase_quotation_items
    @purchase_quotation_items = @purchase_quotation_items.order(created_at: :desc).page(params[:page]).per(20)
  end
  
  
  
  
  def update
    @purchase_quotation_item.update(purchase_quotation_item_params)
  
    redirect_to purchase_quotation_items_path
  end

  def filtered
    @purchase_quotation_items = PurchaseQuotationItem.all
    filter_purchase_quotation_items
    render :index
  end
  

  private

  def set_purchase_quotation_item
    @purchase_quotation_item = PurchaseQuotationItem.find(params[:id])
  end

  def purchase_quotation_item_params
   params.require(:purchase_quotation_item).permit(:result_id)
  end
  

  def authorize_user!
    if @purchase_quotation_item.purchase_quotation.user != current_user
      redirect_to purchase_quotation_items_path, alert: "権限がありません"
    end
  end
  

  def filter_purchase_quotation_items
    if params[:customer_name].present?
      @purchase_quotation_items = @purchase_quotation_items.joins(purchase_quotation: :customer).where("customers.customer_name LIKE ?", "%#{params[:customer_name]}%")
    end
    if params[:quotation_number].present?
      @purchase_quotation_items = @purchase_quotation_items.joins(:purchase_quotation).where("purchase_quotations.quotation_number = ?", params[:quotation_number])
    end
    if params[:category].present?
      @purchase_quotation_items = @purchase_quotation_items.joins(:category).where("categories.category_name LIKE ?", "%#{params[:category]}%")
    end
    if params[:item_name].present?
      @purchase_quotation_items = @purchase_quotation_items.where("item_name LIKE ?", "%#{params[:item_name]}%")
    end
  end
end
