class AnswerNotificationsJob < ActiveJob::Base
  queue_as :default

  def perform(answer)
    answer.question.subscriptions.find_each do |subscription|
      SubscriptionMailer.notify(subscription.user, answer).deliver_now
    end
  end
end
