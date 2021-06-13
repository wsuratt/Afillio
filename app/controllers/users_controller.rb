class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  
  def index
    @pagy, @users = pagy(User.all.order(created_at: :desc))
    authorize @users
  end
  
  def show
  end
  
  def edit
    authorize @user
  end

  def update
    authorize @user
    if @user.update(user_params)
      @user.balance = 50
      redirect_to users_path, notice: 'User roles were successfully updated.'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.friendly.find(params[:id])
  end

  def user_params
    params.require(:user).permit({role_ids: []})
  end
  
end 