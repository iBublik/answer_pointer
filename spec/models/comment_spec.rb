require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to :commentable }

  it { should validate_presence_of :body }
  it { should validate_length_of(:body).is_at_most(150) }
  it { should validate_presence_of :user_id }
  it { should validate_presence_of :commentable_id }
  it { should validate_presence_of :commentable_type }
end
