class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :vendor_info, :vendor_info_update ]
  
  def index
    @pagy, @users = pagy(User.all.order(created_at: :desc))
    authorize @users
  end
  
  def verify_vendors
    @pagy, @users = pagy(User.with_role(:seller).where.not(vendor_title: [nil, ""]))
    authorize @users
  end
  
  def become_vendor
  end
  
  def vendor_info
  end
  
  def vendor_info_update
    # authorize @user
    if @user.has_role?(:seller)
      if @user.update(user_params) && !@user.vendor_title.blank? && (!@user.support_email.blank? || !@user.support_phone.blank? || !@user.support_url.blank?)
        redirect_to become_vendor_user_path(@user), notice: 'User info was successfully submitted.'
      else
        redirect_to vendor_info_user_path(@user), alert: 'Failed to submit user info. Please make sure all required fields are filled out.'
      end
    else
      if @user.update(user_params)
        redirect_to vendor_info_user_path(@user), notice: 'User info was successfully updated.'
      else
        redirect_to vendor_info_user_path(@user), alert: 'Failed to update user info.'
      end
    end
  end
  
  def show
  end
  
  def edit
    authorize @user
  end

  def update
    authorize @user
    if @user.update(user_params)
      redirect_to users_path, notice: 'User roles were successfully updated.'
    else
      render :edit
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