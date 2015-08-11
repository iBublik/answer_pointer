class DailyDigestJob < ActiveJob::Base
  queue_as :default

  def perform
    questions = Question.yesterday
    User.find_each do |user|
      DailyMailer.digest(user, questions).deliver_now
    end
  end
end
