require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'User#Email' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end
end
