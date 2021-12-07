# frozen_string_literal: true

class SupportController < ApplicationController
  skip_before_action :authenticate_user!

  def index; end

  def sign_up; end

  def withdraw_balance; end
end
