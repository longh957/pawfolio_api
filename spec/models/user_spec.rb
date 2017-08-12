require 'rails_helper'

RSpec.describe User, type: :model do
  it 'should have a valid factory' do
    expect(build_stubbed(:user)).to be_valid
  end

  describe 'User#Email' do
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
  end

  describe 'User Pets' do
    it { should have_many(:pets) }
  end
end
