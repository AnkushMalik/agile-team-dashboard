# Meetings controller
class MeetingsController < ApplicationController
  before_action :set_meeting, only: %i[show edit update destroy]

  def index
    @active_meetings = Meeting.active
    @finished_meetings = Meeting.finished
    @meeting = Meeting.new
  end

  def create
    @meeting = Meeting.new(permitted_params)
    if @meeting.save
      flash[:success] = 'Meeting was successfully created'
      redirect_to meetings_path
    else
      flash.now[:error] = 'ohhhhhhhh'
      render :new
    end
  end

  def edit; end

  def update
    if @meeting.update_attributes(permitted_params)
      flash[:success] = 'Meeting was successfully updated'
      redirect_to meetings_path
    else
      flash.now[:error] = 'ohhhhhhhh'
      render :new
    end
  end

  def destroy
    if @meeting.destroy
      flash[:success] = 'Meeting was successfully deleted'
    else
      flash[:error] = 'ohhhhhhhh'
    end
    redirect_to meetings_path
  end

  private

  def set_meeting
    @meeting = Meeting.find(params[:id])
  end

  def permitted_params
    params.require(:meeting).permit(
      :name,
      :event_type,
      :location,
      :start_date,
      :end_date,
      :sprint_id
    )
  end
end
