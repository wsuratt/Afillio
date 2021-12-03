# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def permitted_attributes
    if @user.has_role?(:admin)
      [
        { role_ids: [] },
        :vendor_title, :return_url,
        :support_email,
        :support_phone,
        :support_url,
        :website_url,
        :instagram
      ]
    else
      %i(vendor_title return_url support_email support_phone support_url website_url instagram)
    end
  end

  def index?
    @user.has_role?(:admin)
  end

  def verify_vendors?
    @user.has_role?(:admin)
  end

  def edit?
    @user.has_role?(:admin) || @user.has_role?(:vendor)
  end

  # def vendor_info?
  #   @user.has_role?(:admin) || @user.has_role?(:vendor)
  # end

  # def vendor_info_update?
  #   @user.has_role?(:admin) || @user.has_role?(:vendor)
  # end

  def update?
    @user.has_role?(:admin) || @user.has_role?(:vendor)
  end

  def destroy?
    @user.has_role?(:admin)
  end
end
