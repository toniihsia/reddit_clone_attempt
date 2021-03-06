class SubsController < ApplicationController
  before_action :is_moderator?, only: [:edit, :destroy]
  def index
    @subs = Sub.all
    render :index
  end

  def new
    @sub = Sub.new
    render :new
  end

  def create
    @sub = Sub.new(sub_params)
    if @sub.save
      redirect_to sub_url(@sub)
    else
      render :new
    end
  end

  def show
    @sub = Sub.find(params[:id])
    render :show
  end

  def edit
    @sub = Sub.find(params[:id])
    if @sub
      render :edit
    else
      flash[:errors] << "Can't edit sub that does not exist"
      redirect_to new_sub_url
    end
  end

  def update
    @sub = Sub.find(params[:id])
    if @sub.update(sub_params)
      redirect_to sub_url(@sub)
    else
      render :edit
    end
  end

  def destroy
    @sub = Sub.find(params[:id])
    @sub.destroy
    redirect_to subs_url
  end

  private
  def sub_params
    params.require(:sub).permit(:title, :description, :moderator_id)
  end

  def is_moderator?
    @sub = Sub.find(params[:id])
    redirect_to sub_url(@sub) if current_user.nil? || current_user.id != @sub.moderator_id
  end
end
