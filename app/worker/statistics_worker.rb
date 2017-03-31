class StatisticsWorker
  include Sidekiq::Worker

  def perform
    admin_user = User.find_by id: ENV["admin_id"]
    SendStatisticMailer.send_statistic(admin_user).deliver_now
  end
end
