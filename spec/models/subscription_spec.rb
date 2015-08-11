require 'rails_helper'

RSpec.fdescribe Subscription, type: :model do
  subject { build(:subscription) }

  it { should belong_to(:user) }
  it { should belong_to(:question) }

  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:question_id) }

  # For some reason this test fails despite custom subject
  it { should validate_uniqueness_of(:question_id).scoped_to(:user_id) }
end
