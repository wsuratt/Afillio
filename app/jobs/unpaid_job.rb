# frozen_string_literal: true
class UnpaidJob < ActiveJob::Base
  def perform
    unpaid_orders = Order.where('created_at < ? and paid = ?', 1.week.ago, true)
    unpaid_orders.delete_all
  end
end
