class CustomersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @customers = Customer.all
  
    # 顧客名での検索
    if params[:search].present?
      @customers = @customers.where("customer_name LIKE ?", "%#{params[:search]}%")
    end
  
    @customers = @customers.order(created_at: :desc).page(params[:page]).per(30)
  end

  

  def new
    
    @customer = Customer.new
    @customer.representatives.build # 空のrepresentativeオブジェクトを作成
  end

  def create
    @customer = Customer.new(customer_params)
    if @customer.save
      flash[:success] = '顧客情報が正常に登録されました。'
      redirect_to estimates_path
    else
      flash.now[:error] = '顧客情報の登録に失敗しました。'
      render :new
    end
  end

  def show
    @customer = Customer.find(params[:id])
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
    if @customer.update(customer_params)
      flash[:success] = '顧客情報が正常に更新されました。'
      redirect_to @customer
    else
      flash.now[:error] = '顧客情報の更新に失敗しました。'
      render :edit
    end
  end

  def new_representative
    @customer = Customer.find(params[:customer_id])
    @representative = @customer.representatives.build
  
    respond_to do |format|
      format.js
    end
  end
  

  def create_representative
    @customer = Customer.find(params[:id])
    @representative = @customer.representatives.build(representative_params)
    binding.pry
    if @representative.save
     redirect_to customers_path, notice: '担当者が正常に作成されました。'
    else
      flash.now[:error] = @representative.errors.full_messages.join(", ")
      render :new_representative
    end
  end

  def representatives
    @customer = Customer.find(params[:id])
    @representatives = @customer.representatives
    render json: @representatives
  end

  
  def search
    @customers = Customer.where("name LIKE ?", "%#{params[:q]}%")
    render json: { items: @customers.map { |c| { id: c.id, text: c.name } } }
  end
 

  private

  def customer_params
    params.require(:customer).permit(:customer_name, :customer_code, :address, :phone_number, representatives_attributes: [:id, :department_name, :representative_name, :phone_number, :email, :_destroy])
  end  

  def representative_params
    params.require(:representative).permit(:department_name, :representative_name, :phone_number, :email)
  end
end