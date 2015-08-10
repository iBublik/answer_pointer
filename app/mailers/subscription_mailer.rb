class SubscriptionMailer < ApplicationMailer
  def notify(user, answer)
    @answer = answer
    mail to: user.email, subject: 'New answer for tracked question'
  end
end
