class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end
  
  def permitted_attributes
    if @user.has_role?(:admin)
      [:roles, :vendor_title, :return_url, :support_email, :support_phone, :support_url]
    else
      [:vendor_title, :return_url, :support_email, :support_phone, :support_url]
    end
  end

  def index?
    @user.has_role?(:admin)
  end
  
  def edit?
    @user.has_role?(:admin) || @user.has_role?(:vendor)
  end

  def update?
    @user.has_role?(:admin) || @user.has_role?(:vendor)
  end
  
  def destroy?
    @user.has_role?(:admin)
  end
  
end