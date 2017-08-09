# frozen_string_literal: true

require 'rails_helper'
require 'pry'

describe AuthenticateUserCommand do
  let!(:user) { FactoryGirl.create(:user, id: 1) }

  context 'with correct user and password' do
    before { Timecop.freeze(2017, 1, 1, 0, 0, 1, 1) }
    after { Timecop.return }

    subject { described_class.call(user.email, 'password') }

    let(:expected_token) do
      subject.result
    end

    it 'should respond with a success? = true if password is correct' do
      expect(subject.success?).to be(true)
    end

    it 'should expect result to be the token' do
      expect(subject.result).to eq(expected_token)
    end
  end

  context 'with correct user and wrong password' do
    subject { described_class.call(user.email, 'wrongpassword') }

    it 'success should equal false' do
      expect(subject.success?).to eq(false)
    end

    it 'result should not be valid' do
      expect(subject.result).to eq(nil)
    end
  end

  context 'with incorrect name and password' do
    subject { described_class.call('email@wrong.com', 'wrongpassword') }

    it 'success should be false' do
      expect(subject.success?).to eq(false)
    end

    it 'result should be nil' do
      expect(subject.result).to eq(nil)
    end
  end
end
