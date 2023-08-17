class UnitsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  def index
    @units = Unit.all
  end

  def new
    @units = Unit.new
  end

  def create
    @units = Unit.create(unit_params)
    if @units.all?(&:valid?)
      redirect_to units_path, notice: 'units were successfully created.'
    else
      render :new
    end
  end

  private

  def unit_params
    params.require(:units).map do |p|
      p.permit(:unit_name)
    end
  end
end