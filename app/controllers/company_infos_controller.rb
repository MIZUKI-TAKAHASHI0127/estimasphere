class CompanyInfosController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_company_info, only: [:new, :create]

  def index
    @company_infos = CompanyInfo.all
  end
  
  def new
    @company_info ||= CompanyInfo.new
  end

  def create
    if @company_info.nil?
      @company_info = CompanyInfo.new(company_params)
      if @company_info.save
        redirect_to company_infos_path, notice: 'Company information was successfully created.'
      else
        render :new
      end
    else
      if @company_info.update(company_params)
        redirect_to company_infos_path, notice: 'Company information was successfully updated.'
      else
        render :new
      end
    end
  end
  
  
  def edit
    @company_info = CompanyInfo.find(params[:id])
  end

  def update
    @company_info = CompanyInfo.find(params[:id]) 
    if @company_info.update(company_params)
      flash[:success] = '会社情報が正常に更新されました。'
      redirect_to @company_info
    else
      render :edit
    end
  end
  

  def show
    @company_info = CompanyInfo.find(params[:id])
  end
  
  private

  def set_company_info
    @company_info = CompanyInfo.first || CompanyInfo.new
  end  

  def company_params
    params.require(:company_info).permit(:company_name, :postcode, :address, :phone_number, :fax_number)
  end
end
