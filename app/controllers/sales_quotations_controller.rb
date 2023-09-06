class SalesQuotationsController < ApplicationController
  before_action :authenticate_user!, only: [:preview, :new, :create]
  before_action :set_sales_quotation, only: [:show, :edit, :update]
  

  def new
    @sales_quotation = SalesQuotation.new
    @customers = Customer.all.pluck(:customer_name, :id)
    @representatives = Representative.all.map { |r| [r.department_name + ' - ' + r.representative_name, r.id] }
    20.times { @sales_quotation.sales_quotation_items.build } unless @sales_quotation.sales_quotation_items.size >= 20
  end  

  def create
    @sales_quotation = SalesQuotation.new(sales_quotation_params)
    @sales_quotation.quotation_number = generate_new_quotation_number

    @sales_quotation.sales_quotation_items = @sales_quotation.sales_quotation_items.reject do |item|
      item.category_id.blank? &&
      item.item_name.blank? &&
      item.quantity.blank? &&
      item.unit_id.blank? &&
      item.unit_price.blank? &&
      item.note.blank?
    end
    
    respond_to do |format|
      begin
        if @sales_quotation.save
          format.html { redirect_to preview_sales_quotation_path(@sales_quotation), notice: 'Sales quotation was successfully created and preview is ready.' }
          format.json { render :show, status: :created, location: @sales_quotation }
        else
          @customers = Customer.all
          @representatives = Representative.all
          format.html { render :new }
          format.json { render json: @sales_quotation.errors, status: :unprocessable_entity }
    
        end
      rescue => e
        logger.error "Error in creating sales quotation: #{e.message}"
        raise e
      end
    end
  end
  
  
  def index
    @sales_quotations = SalesQuotation.includes(sales_quotation_items: [:unit, :category])
  
    # 顧客名での検索
    if params[:customer_name].present?
      @sales_quotations = @sales_quotations.joins(:customer).where("customers.customer_name LIKE ?", "%#{params[:customer_name]}%")
    end
  
    # 見積番号での検索
    if params[:quotation_number].present?
      @sales_quotations = @sales_quotations.where(quotation_number: params[:quotation_number])
    end
  
    # カテゴリーでの検索
    if params[:category_name].present?
      @sales_quotations = @sales_quotations.joins(sales_quotation_items: :category).where("categories.category_name LIKE ?", "%#{params[:category_name]}%")
    end
  
    # 品名での検索
    if params[:item_name].present?
      @sales_quotations = @sales_quotations.joins(:sales_quotation_items).where("sales_quotation_items.item_name LIKE ?", "%#{params[:item_name]}%")
    end
  
    # 最後にソートとページネーションを適用
    @sales_quotations = @sales_quotations.order(created_at: :desc).page(params[:page]).per(20)
  end
  

  def show
    @sales_quotation = SalesQuotation.find(params[:id])
    @customer = @sales_quotation.customer
    @company_info = CompanyInfo.first
    @user = @sales_quotation.user

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "sales_quotations/show",
               template: "sales_quotations/show",
               encoding: "UTF-8",
               font_name: "IPAexMincho",
               formats: [:html],
               layout: 'pdf',
               disposition: 'attachment' # ブラウザでPDFを開くのではなく、ダウンロードさせる
      end
    end
  end

  def edit
  end

  def update
    if @sales_quotation.update(sales_quotation_params)
      redirect_to @sales_quotation, notice: '見積書を更新しました。'
    else
      render :edit
    end
  end

  
  def requote
    original_quotation = SalesQuotation.find(params[:id])
    new_quotation = original_quotation.dup
    new_quotation.quotation_number = generate_new_quotation_number # ここで新規見積番号を生成
    original_quotation.sales_quotation_items.each do |item|
      new_quotation.sales_quotation_items.build(item.attributes.except("id", "created_at", "updated_at", "quotation_id"))
    end
    if new_quotation.save
      redirect_to new_quotation, notice: '新しい見積書を作成しました。'
    else
      @sales_quotation = original_quotation
      flash.now[:alert] = '新しい見積書の作成に失敗しました。'
      render :show
    end
  end

  def new_item
    @sales_quotation = SalesQuotation.new
    @sales_quotation.sales_quotation_items.build
    render partial: 'sales_quotation_item_fields', locals: { f: @sales_quotation.sales_quotation_items.last }
  end
  
  def preview
    @sales_quotation = SalesQuotation.find(params[:id])
    @customer = @sales_quotation.customer
    @company_info = CompanyInfo.first
    @user = @sales_quotation.user
  end

  private

  def set_sales_quotation
    @sales_quotation = SalesQuotation.find(params[:id])
  end

  def sales_quotation_params
    params.require(:sales_quotation).permit(
      :customer_id,
      :representative_id, 
      :request_date, 
      :quotation_date, 
      :quotation_due_date, 
      :delivery_date, 
      :delivery_place, 
      :trading_conditions,
      sales_quotation_items_attributes: [
        :id, 
        :item_name, 
        :quantity, 
        :category_id, 
        :unit_id, 
        :unit_price, 
        :note, 
        :_destroy
      ]
    ).merge(user_id: current_user.id)
  end

  def representative_options
    customer = Customer.find(params[:id])
    @representatives = customer.representatives
    render partial: "representative_options", locals: { representatives: @representatives }
  end  
end