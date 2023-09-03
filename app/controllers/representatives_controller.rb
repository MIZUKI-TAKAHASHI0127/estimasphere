class RepresentativesController < ApplicationController
  def create
    @customer = Customer.find(params[:customer_id])
    @representative = @customer.representatives.build(representative_params)
    
    if @representative.save
      redirect_to customer_path(@customer), notice: '担当者が正常に登録されました。'
    else
      render :new
    end
  end

  def new
    @customer = Customer.find(params[:customer_id])
    @representative = @customer.representatives.build
  end

  def index
    if params[:customer_id].present?
      @representatives = Representative.where(customer_id: params[:customer_id])
      render json: { representatives: @representatives.map { |r| [r.department_name + ' - ' + r.representative_name, r.id] } }
    else
      render json: { error: 'customer_id parameter is missing' }, status: :bad_request
    end
  end

  def update_representatives
    customer = Customer.find(params[:id])
    @representatives = customer.representatives
    render partial: "sales_quotations/representative_options", locals: { representatives: @representatives }

  end
  

  
  private

  def representative_params
    params.require(:representative).permit(:department_name, :representative_name, :phone_number, :email)
  end
end