class UsersController < ApplicationController
  before_action :set_user, only: [:show, :vendor_info, :edit, :update, :destroy]
  
  def index
    @pagy, @users = pagy(User.all.order(created_at: :desc))
    authorize @users
  end
  
  def vendor_info
  end
  
  def show
  end
  
  def edit
    authorize @user
  end

  def update
    authorize @user
    if current_user.has_role?(:admin)
      if @user.update(user_params)
        redirect_to users_path, notice: 'User roles were successfully updated.'
      else
        render :edit
      end
    else
      if @user.update(user_params)
        redirect_to users_vendor_info_path(current_user), notice: 'User info was successfully updated.'
      else
        redirect_to users_vendor_info_path(current_user), alert: 'Failed to update user info.'
      end
    end
  end
  
  def destroy
    authorize @user
    if @user.destroy
      respond_to do |format|
        format.html { redirect_to users_path, notice: 'User was successfully deleted.' }
        format.json { head :no_content }
      end
    else
      redirect_to @user, alert: 'User could not be deleted.'
    end
  end

  private

  def set_user
    @user = User.friendly.find(params[:id])
  end

  def user_params
    params.require(:user).permit(policy(@user).permitted_attributes)
  end
  
end 