describe DecodeAuthenticationCommand do
  include ActiveSupport::Testing::TimeHelpers

  context 'Valid Token' do
    before { travel_to Time.zone.local(2017, 1, 1) }
    after { travel_back }

    let!(:user) { FactoryGirl.create(:user, id: 1) }
    let(:expired_header) do
      contents = {
        user_id: user.id,
        name: user.name,
        exp: 30.days.from_now.to_i,
      }
      token = JwtService.encode(contents)
      return {
        'Authorization' => "Bearer #{token}",
      }
    end

    subject { described_class.call(expired_header) }

    it 'expect errors to be empty' do
      expect(subject.errors).to be_empty
    end

    it 'expect success to be true for valid token' do
      expect(subject.success?).to be
    end
  end

  context 'missing token' do
    subject { described_class.call('') }

    it 'expect success? to be false' do
      expect(subject.success?).to eq(false)
    end

    it 'expect errors to include token' do
      expect(subject.errors.keys).to include(:token)
    end

    it 'expect error message to be Token Missing' do
      expect(subject.errors.values.flatten).to include('Token Missing')
    end
  end

  context 'Expired Token' do
    let!(:user) { FactoryGirl.create(:user, id: 1) }
    let(:expired_header) do
      contents = {
        user_id: user.id,
        name: user.name,
        exp: 30.days.ago.to_i,
      }
      token = JwtService.encode(contents)
      return {
        'Authorization' => "Bearer #{token}",
      }
    end

    subject { described_class.call(expired_header) }

    it 'expect success to be false' do
      expect(subject.success?).to_not be
    end

    it 'expect error object to include token' do
      expect(subject.errors.keys).to include(:token)
    end

    it 'expect error message to be Token Expired' do
      expect(subject.errors.values.flatten).to include('Token Expired')
    end
  end
end
