# frozen_string_literal: true

describe JwtService do
  subject { described_class }

  let(:payload) { { 'name' => 'test' } }
  let(:token) { 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJuYW1lIjoidGVzdCJ9.5T8Jzzjd0t6EZNcSPg_BOlMWgbeL5AZTMoF7pwuUKh4' }

  describe '#decode' do
    it 'Should correctly decode the JWT' do
      expect(subject.decode(token)).to eq(payload)
    end
  end

  describe '#encode' do
    it 'Should correctly encode the payload' do
      expect(subject.encode(payload)).to eq(token)
    end
  end
end
