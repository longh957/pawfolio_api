require 'rails_helper'

RSpec.describe 'Registration Requests', type: :request do
  describe 'POST /api/v1/registration'  do
    let(:valid_params) { { email: Faker::Internet.email, password: 'password', name: Faker::GameOfThrones.character } }
    let(:invalid_params) { { name: '' } }

    context 'Create User - Valid Request' do
      before { post '/api/v1/registration', params: valid_params }

      it 'returns status code :created for a valid request' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'Created User - Invalid Request' do
      before { post '/api/v1/registration', params: invalid_params }

      it 'should return :bad_request for invalid request' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe 'PUT /api/v1/registration' do
    let(:user) { create(:user, id: 1) }
    let(:params) { { name: 'jon snow', email: 'jon@winterfell.com' } }
    let(:header) do
      valid_user = AuthenticateUserCommand.call(user.email, 'password')
      token = valid_user.result
      return {
        'Authorization' => "Bearer #{token}",
      }
    end

    context 'Update User - Valid Request' do
      before { put('/api/v1/registration', params: params, headers: header) }

      it 'returns status code :accepted' do
        expect(response).to have_http_status(:accepted)
      end

      it 'should update the name' do
        user = User.find(1)
        expect(user.name).to eq('jon snow')
      end

      it 'should update the email' do
        user = User.find(1)
        expect(user.email).to eq('jon@winterfell.com')
      end
    end

    context 'Update User - Request Missing Token' do
      before { put('/api/v1/registration', params: params) }

      it 'returns status code :unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/registration' do
    let(:user) { create(:user, id: 1) }
    let(:valid_params) { { password: 'password' } }
    let(:header) do
      valid_user = AuthenticateUserCommand.call(user.email, 'password')
      token = valid_user.result
      return {
        'Authorization' => "Bearer #{token}",
      }
    end

    context 'Delete User - valid request' do
      before { delete('/api/v1/registration', params: valid_params, headers: header) }

      it 'returns status code :accepted' do
        expect(response).to have_http_status(:accepted)
      end

      it 'should delete the user' do
        expect { User.find(1) }.to raise_exception(ActiveRecord::RecordNotFound)
      end
    end

    context 'Delete User - Missing Password' do
      before { delete('/api/v1/registration', params: {}, headers: header) }

      it 'returns http status :bad_request' do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'Delete User - Bad Password' do
      before { delete('/api/v1/registration', params: { password: '1' }, headers: header) }

      it 'returns http status :bad_request' do
        expect(response).to have_http_status(:bad_request)
      end
    end

    context 'Delete User - Missing Headers' do
      before { delete('/api/v1/registration', params: valid_params) }

      it 'returns http status :unauthroized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
