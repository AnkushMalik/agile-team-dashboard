# Absence controller
class AbsencesController < ApplicationController
  before_action :set_absence, only: %i[show edit update destroy]

  def index
    @absences = current_user.absences
    @absence = Absence.new
  end

  def create
    @absence = Absence.new(permitted_params)
    if @absence.save
      flash[:success] = 'Absence was successfully created'
      redirect_to absences_path
    else
      flash.now[:error] = 'ohhhhhhhh'
      render :new
    end
  end

  def edit; end

  def update
    if @absence.update_attributes(permitted_params)
      flash[:success] = 'Absence was successfully updated'
      redirect_to absences_path
    else
      flash.now[:error] = 'ohhhhhhhh'
      render :new
    end
  end

  def destroy
    if @absence.destroy
      flash[:success] = 'Absence was successfully deleted'
    else
      flash[:error] = 'ohhhhhhhh'
    end
    redirect_to absences_path
  end

  private

  def set_absence
    @absence = Absence.find(params[:id])
  end

  def permitted_params
    params.require(:absence).permit(
      :user_id,
      :location,
      :event_type,
      :start_date,
      :end_date,
      :description
    )
  end
end
