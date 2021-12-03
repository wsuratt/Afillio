# frozen_string_literal: true

class OrderMailer < ApplicationMailer
  def new_order_email
    @order = params[:order]

    mail(to: @order.email, subject: 'Order confirmation')
  end

  def shipped_order_email
    @order = params[:order]

    mail(to: @order.email, subject: 'Order shipped')
  end

  def vendor_email
    @user = params[:user]

    mail(to: @user.email, subject: 'New order')
  end
end
