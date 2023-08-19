class RepresentativesController < ApplicationController
  def create
    @customer = Customer.find(params[:customer_id])
    @representative = @customer.representatives.build(representative_params)
    
    if @representative.save
      redirect_to representatives_path, notice: '担当者が正常に登録されました。'
    else
      render :new
    end
  end

  private

  def representative_params
    params.require(:representative).permit(:department_name, :representative_name, :phone_number, :email)
  end
end