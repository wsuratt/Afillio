#app/workers/unpaid_worker.rb
class UnpaidWorker
  include Sidekiq::worker
  def perform
    unpaid_orders = Order.where('created_at < ? and paid = ?', 1.week.ago, true)
    unpaid_orders.delete_all
  end
end