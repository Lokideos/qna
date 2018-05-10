class NotificationMailer < ApplicationMailer
  def notification(question, user)
    @title = question.title

    mail to: user.email
  end
end
