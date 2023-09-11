class SalesQuotationsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]
  before_action :set_sales_quotation, only: [:show]

  

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
          format.html { redirect_to sales_quotation_path(@sales_quotation), notice: 'sales quotation was successfully created and show is ready.' }
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
               formats: [:pdf],
               layout: 'pdf',
               disposition: 'attachment' # ブラウザでPDFを開くのではなく、ダウンロードさせる
      end
    end
  end
  
  def requote
    # 元の見積を探す
    original_quotation = SalesQuotation.find(params[:id])
    
    # 新しい見積オブジェクトを作成し、内容をコピー
    new_quotation = original_quotation.dup
    new_quotation.quotation_number = generate_new_quotation_number
    
    if new_quotation.save

        session[:allowed_to_edit] = new_quotation.id
        # 見積アイテムをコピー
        original_quotation.sales_quotation_items.each do |item|
            copied_item = item.dup
            copied_item.sales_quotation_id = new_quotation.id
            copied_item.save
        end
        
        # 成功した場合、新しい見積の編集ページにリダイレクト
        redirect_to edit_sales_quotation_path(new_quotation), notice: '再見積が正常に作成されました。内容を編集してください。'
    else
        # 失敗した場合、エラーメッセージを表示して元のページに戻る
        flash[:alert] = '再見積の作成に失敗しました。'
        redirect_back(fallback_location: sales_quotations_path)
    end
end
  
  def edit
    @sales_quotation = SalesQuotation.find(params[:id])
    @sales_quotation_items = @sales_quotation.sales_quotation_items

    unless session[:allowed_to_edit] == @sales_quotation.id
      flash[:alert] = '再見積を経由してのみ、この見積を編集できます。'
      redirect_to sales_quotation_path(@sales_quotation)
      return
    end
  
    # セッションのキーを削除して、次回からのアクセスを制限
    session.delete(:allowed_to_edit)
    
    # 既存のアイテム数に基づいて追加の行を作成
    additional_rows = 20 - @sales_quotation_items.size
    additional_rows.times { @sales_quotation.sales_quotation_items.build } if additional_rows > 0
  
    @customers = Customer.all.pluck(:customer_name, :id)
    @representatives = Representative.all.map { |r| [r.department_name + ' - ' + r.representative_name, r.id] }
  end
  
  def update
    @sales_quotation = SalesQuotation.find(params[:id])
  
    if @sales_quotation.update(sales_quotation_params)
        redirect_to sales_quotation_path(@sales_quotation), notice: 'sales quotation was successfully updated.'
    else
        @representatives = Representative.all.map { |r| [r.department_name + ' - ' + r.representative_name, r.id] }
        @sales_quotation_items = @sales_quotation.sales_quotation_items
        flash.now[:alert] = '見積の更新に失敗しました。'
        render :edit
    end
  end


  def new_item
    @sales_quotation = SalesQuotation.new
    @sales_quotation.sales_quotation_items.build
    render partial: 'sales_quotation_item_fields', locals: { f: @sales_quotation.sales_quotation_items.last }
  end

  def generate_pdf
    @sales_quotation = SalesQuotation.find(params[:id])
    @customer = @sales_quotation.customer
    @company_info = CompanyInfo.first
    @user = @sales_quotation.user
  
    require 'prawn'
    require 'prawn/table'
  
    Prawn::Document.generate('sales_quotation.pdf', page_layout: :landscape) do |pdf|
      # フォントを設定
      pdf.font_families.update("NotoSansJP" => {
        normal: Rails.root.join('app/assets/fonts/NotoSansJP-Regular.ttf')
      })
  
      # NotoSansJP フォントを使用
      pdf.font("NotoSansJP")
  
      # タイトル部分
      pdf.text "販売見積書", size: 30, align: :center
      pdf.move_down 30
  
  
      # 顧客情報部分
      representative = @sales_quotation.representative
      customer_info = @customer.customer_name

      if representative.representative_name.present?
        customer_info += "\n#{representative.department_name}" if representative.department_name.present?
        customer_info += "\n#{representative.representative_name} 様"
      else
        customer_info += "\n#{representative.department_name} 御中" if representative.department_name.present?
      end

  
      quotation_date = @sales_quotation.quotation_date.strftime("%Y年%m月%d日")
      quotation_number = @sales_quotation.quotation_number
  
      data = [[customer_info, "見 積 日: #{quotation_date}\n見積番号: #{quotation_number}"]]
  
      #pdf.table(data, column_widths: [345, 345], cell_style: { borders: [] })
      pdf.table(data, cell_style: { borders: [] }) do |t|
        # 左列のデータを左端に配置
        t.columns(0).style(align: :left)
        # 右列のデータを右端に配置 & 左側のパディングを増やしてデータをさらに右に寄せる
        t.columns(1).style(align: :right, padding_left: 180)
      end

      pdf.move_down 30
  
      # 会社情報
      company_info = @company_info&.company_name || "未登録"
      company_address = @company_info&.address || "未登録"
      phone_number = @company_info&.phone_number || "未登録"
      fax_number = @company_info&.fax_number || "未登録"
      user_name = "#{@user.last_name} #{@user.first_name}"
  
      data = [
        ["", "会社名: #{company_info}"],
        ["有効期限: #{@sales_quotation.quotation_due_date.strftime("%Y年%m月%d日")}", "住所: #{company_address}"],
        ["納入場所: #{@sales_quotation.delivery_place}", "電話番号: #{phone_number}"],
        ["納 入 日: #{@sales_quotation.delivery_date.strftime("%Y年%m月%d日")}", "FAX番号: #{fax_number}"],
        ["取引条件: #{@sales_quotation.trading_conditions}", "担当: #{user_name}"]
      ]
      
      pdf.table(data, cell_style: { borders: [] }) do |t|
        # 左列のデータを左端に配置
        t.columns(0).style(align: :left)
        # 右列のデータを右端に配置 & 左側のパディングを増やしてデータをさらに右に寄せる
        t.columns(1).style(align: :right, padding_left: 270)
      end
      #pdf.table(data, column_widths: [345, 345], cell_style: { borders: [] })

      pdf.move_down 30
  
      # 商品一覧テーブル
      items_data = [["No.", "品名", "数量", "単位", "単価", "金額", "備考"]]
      @sales_quotation.sales_quotation_items.each_with_index do |item, index|
        items_data << [
          index + 1,
          item.item_name,
          item.quantity,
          item.unit.unit_name,
          "#{number_with_delimiter(item.unit_price)}円",
          "#{number_with_delimiter(item.quantity * item.unit_price)}円",
          item.note
        ]
      end
      total = @sales_quotation.sales_quotation_items.sum { |item| item.quantity * item.unit_price }
      items_data << ["", "", "", "", "合計金額:", "#{number_with_delimiter(total)}円", ""]
  
      pdf.table(items_data, header: true, column_widths: {0 => 35, 1 => 160, 2 => 70, 3 => 50, 4 => 100, 5 => 120, 6 => 140}) do |table|
        table.columns([0,2, 4, 5]).style(align: :right)
        table.row(0).style(align: :center)

         # totalの前の行の下線を太くする
        table.row(items_data.length - 2).bottom_border_width = 2
  
        # totalの行の上線を太くする
        table.row(items_data.length - 1).top_border_width = 2
      end

      pdf.repeat(:all, dynamic: true) do
        # 現在のページ番号を取得
        current_page_number = pdf.page_number
        
        if current_page_number > 1
          pdf.bounding_box([pdf.bounds.right - 150, pdf.bounds.bottom + 30], width: 150, height: 30) do
            pdf.text "見積番号: #{quotation_number}"
            pdf.text "会社名: #{company_info}"
          end
        end
      end
      
      
    
  
      # ページ番号追加
      pdf.number_pages "<page>/<total>", {
        start_count_at: 1,
        page_filter: :all,
        at: [pdf.bounds.right / 2 - 50, 0],
        align: :center,
        size: 14
      }
      
      send_data pdf.render, filename: "sales_quotation_#{params[:id]}.pdf",
                            type: 'application/pdf',
                            disposition: 'attachment'
    end
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

  def generate_new_quotation_number
    date_prefix = Date.today.strftime('S%Y%m%d-')
    last_quotation = SalesQuotation.where('quotation_number LIKE ?', "#{date_prefix}%").order(:quotation_number).last
    if last_quotation.nil?
      "#{date_prefix}001"
    else
      number = last_quotation.quotation_number.split('-').last.to_i
      "#{date_prefix}#{sprintf('%03d', number + 1)}"
    end
  end

  def number_with_delimiter(number)
    number.to_s.gsub(/(\d)(?=(\d{3})+(?!\d))/, '\\1,')
  end
  
end