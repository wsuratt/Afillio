class OrderPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    @user.has_role?(:admin)
  end

  def update?
    @user.has_role?(:admin) || @record.user == @user
  end

  def destroy?
    @user.has_role?(:admin) || @record.user == @user
  end
end