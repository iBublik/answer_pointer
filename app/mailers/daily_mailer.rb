class DailyMailer < ApplicationMailer
  def digest(user, questions)
    @questions = questions
    mail to: user.email, subject: 'Questions asked yesterday'
  end
end
