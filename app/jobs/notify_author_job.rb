class NotifyAuthorJob < ApplicationJob
  queue_as :default

  def perform(answer)
    Answer.send_notification_to_subscribers(answer)
  end
end
