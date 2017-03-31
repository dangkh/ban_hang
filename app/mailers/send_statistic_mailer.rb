class SendStatisticMailer < ApplicationMailer

  def send_statistic user
    @user = user
    mail to: @user.email, subject: "statistic"
  end
end
