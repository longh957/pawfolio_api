require 'rails_helper'

RSpec.describe 'Password Requests', type: :request do
  describe 'POST /api/v1/passwords' do
    let(:user) { create(:user, id: 1) }
    let(:params) { { email: user.email } }

    context 'Password Reset - Valid Request' do
      before { post '/api/v1/passwords', params: params }

      it 'returns status code :ok for a valid request' do
        expect(response).to have_http_status(:ok)
      end
    end

    context 'Password Reset - Invalid Request' do
      before { post '/api/v1/passwords', params: { email: 'xxxx' } }

      it 'returns status code :bad_request' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'PUT /api/v1/passwords' do
    let(:user) { create(:user, id: 1) }
    let(:params) { { password: 'password123' } }

    context 'Update Password - Valid Request' do
      before do
        user.generate_password_reset_token!
        put "/api/v1/passwords/#{user.password_reset_token}", params: params
      end

      it 'returns status code :ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'deletes the password_reset_token after update' do
        user = User.find(1)
        expect(user.password_reset_token).to be_nil
      end

      it 'successfully updates the password' do
        user = User.find(1)
        expect(user.authenticate('password123')).to eq(user)
      end
    end

    context 'Update Password - Invalid Token' do
      let(:params) { { password: 'password123' } }
      before { put '/api/v1/passwords/safdasdfa', params: params }

      it 'should return :unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'Update Password - Missing Token' do
      it 'should return :unauthorized' do
        expect { put '/api/v1/passwords/' }.to raise_error(ActionController::RoutingError)
      end
    end

    context 'Update Password - Missing password' do
      let(:user) { create(:user, id: 1) }
      let(:params) { { password: '' } }
      before do
        user.generate_password_reset_token!
        put "/api/v1/passwords/#{user.password_reset_token}", params: params
      end

      it 'should return :unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
