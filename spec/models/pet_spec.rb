require 'rails_helper'

RSpec.describe Pet, type: :model do
  it 'should have a valid Factory' do
    expect(build_stubbed(:pet)).to be_valid
  end

  it { should belong_to(:user) }
  it { should validate_presence_of(:name) }
end
