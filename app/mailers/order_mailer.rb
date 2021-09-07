class OrderMailer < ApplicationMailer
  def new_order_email
    @order = params[:order]

    mail(to: @order.email, subject: "Order confirmation")
  end
  
  def shipped_order_email
    @order = params[:order]

    mail(to: @order.email, subject: "Order shipped")
  end
end
