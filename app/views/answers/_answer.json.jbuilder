json.(answer, :id, :body, :user_id, :question_id, :rating)

json.attachments answer.attachments do |attachment|
  json.(attachment, :id, :attachable_id, :attachable_type)
  json.file do
    json.identifier   attachment.file.identifier
    json.url          attachment.file.url
  end
end

json.answers_count answer.question.answers.count
