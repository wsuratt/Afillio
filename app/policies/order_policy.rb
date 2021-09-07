class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    @user.has_role?(:admin)
  end
  
  def tracking_number
    @user.has_role?(:admin) || @record.user == @user
  end
  
  def tracking_number_update
    @user.has_role?(:admin) || @record.user == @user
  end

  def update?
    @user.has_role?(:admin) || @record.user == @user
  end

  def destroy?
    @user.has_role?(:admin) || @record.user == @user
  end
  
end