class PurchaseQuotationsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :set_purchase_quotation, only: [:show, :edit, :update]
  

  def new
    @purchase_quotation = PurchaseQuotation.new
    @customers = Customer.all.pluck(:customer_name, :id)
    @representatives = Representative.all.map { |r| [r.department_name + ' - ' + r.representative_name, r.id] }
    20.times { @purchase_quotation.purchase_quotation_items.build } unless @purchase_quotation.purchase_quotation_items.size >= 20
  end  

  def create
    @purchase_quotation = PurchaseQuotation.new(purchase_quotation_params)
    @purchase_quotation.quotation_number = generate_new_quotation_number

    @purchase_quotation.purchase_quotation_items = @purchase_quotation.purchase_quotation_items.reject do |item|
      item.category_id.blank? &&
      item.item_name.blank? &&
      item.quantity.blank? &&
      item.unit_id.blank? &&
      item.unit_price.blank? &&
      item.note.blank?
    end
    
    respond_to do |format|
      begin
        if @purchase_quotation.save
          format.html { redirect_to purchase_quotation_path(@purchase_quotation), notice: 'purchase quotation was successfully created and show is ready.' }
          format.json { render :show, status: :created, location: @purchase_quotation }
        else
          @customers = Customer.all
          @representatives = Representative.all
          format.html { render :new }
          format.json { render json: @purchase_quotation.errors, status: :unprocessable_entity }
    
        end
      rescue => e
        logger.error "Error in creating purchase quotation: #{e.message}"
        raise e
      end
    end
  end
  
  
  def index
    @purchase_quotations = PurchaseQuotation.includes(purchase_quotation_items: [:unit, :category])
  
    # 顧客名での検索
    if params[:customer_name].present?
      @purchase_quotations = @purchase_quotations.joins(:customer).where("customers.customer_name LIKE ?", "%#{params[:customer_name]}%")
    end
  
    # 見積番号での検索
    if params[:quotation_number].present?
      @purchase_quotations = @purchase_quotations.where(quotation_number: params[:quotation_number])
    end
  
    # カテゴリーでの検索
    if params[:category_name].present?
      @purchase_quotations = @purchase_quotations.joins(purchase_quotation_items: :category).where("categories.category_name LIKE ?", "%#{params[:category_name]}%")
    end
  
    # 品名での検索
    if params[:item_name].present?
      @purchase_quotations = @purchase_quotations.joins(:purchase_quotation_items).where("purchase_quotation_items.item_name LIKE ?", "%#{params[:item_name]}%")
    end
  
    # 最後にソートとページネーションを適用
    @purchase_quotations = @purchase_quotations.order(created_at: :desc).page(params[:page]).per(20)
  end
  

  def show
    @purchase_quotation = PurchaseQuotation.find(params[:id])
    @customer = @purchase_quotation.customer
    @company_info = CompanyInfo.first
    @user = @purchase_quotation.user

    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "purchase_quotations/show",
               template: "purchase_quotations/show",
               encoding: "UTF-8",
               font_name: "IPAexMincho",
               formats: [:pdf],
               layout: 'pdf',
               disposition: 'attachment' # ブラウザでPDFを開くのではなく、ダウンロードさせる
      end
    end
  end

  def edit
    puts "Edit action is being called"
    @purchase_quotation = PurchaseQuotation.find(params[:id])
    @purchase_quotation_items = @purchase_quotation.purchase_quotation_items
    
    # 既存のアイテム数に基づいて追加の行を作成
    additional_rows = 20 - @purchase_quotation_items.size
    additional_rows.times { @purchase_quotation.purchase_quotation_items.build } if additional_rows > 0
  
    @customers = Customer.all.pluck(:customer_name, :id)
    @representatives = Representative.all.map { |r| [r.department_name + ' - ' + r.representative_name, r.id] }
  end
  
  def update
    @purchase_quotation = PurchaseQuotation.find(params[:id])
  
    if @purchase_quotation.update(purchase_quotation_params)
      # 新しい見積番号を生成
      new_quotation = @purchase_quotation.dup
      new_quotation.quotation_number = generate_new_quotation_number
      new_quotation.purchase_quotation_items = @purchase_quotation.purchase_quotation_items.map(&:dup) # この行をここに移動
  
      # customer_id、representative_id、その他の属性を設定
      new_quotation.customer_id = params[:purchase_quotation][:customer_id]
      new_quotation.representative_id = params[:purchase_quotation][:representative_id]
  
      if new_quotation.save
        redirect_to purchase_quotation_path(@purchase_quotation), notice: 'purchase quotation was successfully created and show is ready.'
      else
        puts new_quotation.errors.full_messages # この行を追加
        new_quotation.purchase_quotation_items.each do |item|
          puts item.errors.full_messages
        end
        @representatives = Representative.all.map { |r| [r.department_name + ' - ' + r.representative_name, r.id] }
        @purchase_quotation_items = @purchase_quotation.purchase_quotation_items
        flash.now[:alert] = '新しい見積の作成に失敗しました。'
        render :edit
      end
    else
      render :edit
    end
  end
  
  

  def new_item
    @purchase_quotation = PurchaseQuotation.new
    @purchase_quotation.purchase_quotation_items.build
    render partial: 'purchase_quotation_item_fields', locals: { f: @purchase_quotation.purchase_quotation_items.last }
  end

  private

  def set_purchase_quotation
    @purchase_quotation = PurchaseQuotation.find(params[:id])
  end

  def purchase_quotation_params
    params.require(:purchase_quotation).permit(
      :customer_id,
      :representative_id, 
      :request_date, 
      :quotation_date, 
      :quotation_due_date, 
      :delivery_date, 
      :handover_place, 
      :trading_conditions,
      purchase_quotation_items_attributes: [
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

  def generate_new_quotation_number
    date_prefix = Date.today.strftime('P%Y%m%d-')
    last_quotation = PurchaseQuotation.where('quotation_number LIKE ?', "#{date_prefix}%").order(:quotation_number).last
    if last_quotation.nil?
      "#{date_prefix}001"
    else
      number = last_quotation.quotation_number.split('-').last.to_i
      "#{date_prefix}#{sprintf('%03d', number + 1)}"
    end
  end
end