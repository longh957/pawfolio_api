require 'rails_helper'

RSpec.describe 'Pet Requests', type: :request do
  let(:user) { create(:user_with_pets, id: 1) }
  let(:user_no_pets) { create(:user, id: 2) }
  let(:header) do
    valid_user = AuthenticateUserCommand.call(user.email, 'password')
    token = valid_user.result
    return {
      'Authorization' => "Bearer #{token}",
    }
  end
  let(:header_no_pets) do
    valid_user = AuthenticateUserCommand.call(user_no_pets.email, 'password')
    token = valid_user.result
    return {
      'Authorization' => "Bearer #{token}",
    }
  end

  let(:pet_params) { { name: Faker::DragonBall.character, dob: Faker::Date.birthday(1, 18), user: user } }

  describe 'GET /api/v1/pets' do
    context 'PET INDEX - Valid Request with pets' do
      before { get '/api/v1/pets', headers: header }

      it 'responds with :ok for a valid request' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds with an array of pets' do
        result = JSON.parse(response.body)
        expect(result['pets']).to be_instance_of(Array)
      end

      it "responds with user's pets" do
        result = JSON.parse(response.body).dig('pets')
        expect(result.size).to eq(user.pets.size)
      end
    end

    context 'PET INDEX - Valid Request no pets' do
      before { get '/api/v1/pets', headers: header_no_pets }

      it 'responds with :ok for a valid request' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds with an array of pets' do
        result = JSON.parse(response.body)
        expect(result['pets']).to be_instance_of(Array)
      end

      it 'responds with empty array of pets' do
        result = JSON.parse(response.body).dig('pets')
        expect(result.size).to eq(0)
      end
    end

    context 'PET INDEX = Invalid Request' do
      before { get '/api/v1/pets' }

      it 'responds with :unauthorized for an invalid request' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/pets/:id' do
    let(:pet) { user.pets.first }

    context 'PET SHOW - Valid Request' do
      before { get "/api/v1/pets/#{pet.id}", headers: header }

      it 'responds with :ok for a valid request' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds with a single pet' do
        result = JSON.parse(response.body).dig('pet')
        expect(result).to be_instance_of(Hash)
      end
    end

    context 'PET SHOW - Trying to access another user pet' do
      before { get "/api/v1/pets/#{pet.id}", headers: header_no_pets }

      it 'responds with :ok for a valid request' do
        expect(response).to have_http_status(:ok)
      end

      it 'has message for not authorized' do
        result = JSON.parse(response.body).dig('pet')
        expect(result).to eq('Not Found')
      end
    end

    context 'PET SHOW - No headers' do
      before { get "/api/v1/pets/#{pet.id}" }

      it 'returns unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/v1/pets' do
    context 'PET CREATE - Valid Request' do
      before { post '/api/v1/pets', params: pet_params, headers: header }

      it 'responds with status :ok for a valid create request' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds with the pet object' do
        result = JSON.parse(response.body).dig('pet')
        expect(result['name']).to eq(pet_params[:name])
      end
    end

    context 'PET CREATE - No Headers' do
      before { post '/api/v1/pets', params: pet_params }

      it 'responds with status :ok for a valid create request' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'PET CREATE - No params' do
      before { post '/api/v1/pets', params: {}, headers: header }

      it 'responds with status :unprocessable_entity for a valid create request' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT /api/v1/pets/:id' do
    let(:pet) { user.pets.first }
    let(:update_params) { { name: 'Drogon' } }

    context 'PET UPDATE - Valid Request' do
      before { put "/api/v1/pets/#{pet.id}", params: update_params, headers: header }

      it 'responds with status :ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'responds with a single pet' do
        result = JSON.parse(response.body).dig('pet')
        expect(result).to be_instance_of(Hash)
      end

      it 'responds with the updated pet object' do
        result = JSON.parse(response.body).dig('pet')
        expect(result['name']).to eq(update_params[:name])
      end
    end

    context 'PET UPDATE - Trying to access another user pet' do
      before { put "/api/v1/pets/#{pet.id}", headers: header_no_pets }

      it 'responds with :ok for a valid request' do
        expect(response).to have_http_status(:ok)
      end

      it 'has message for not authorized' do
        result = JSON.parse(response.body).dig('pet')
        expect(result).to eq('Not Found')
      end
    end

    context 'PET UPDATE - No headers' do
      before { put "/api/v1/pets/#{pet.id}" }

      it 'returns unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE /api/v1/pets/:id' do
    let(:pet) { user.pets.first }

    context 'PET DELETE - Valid request' do
      before { delete "/api/v1/pets/#{pet.id}", params: {}, headers: header }

      it 'responds with :ok for a valid request' do
        expect(response).to have_http_status(:ok)
      end

      it 'deletes the pet' do
        expect { Pet.find(pet.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'PET DELETE - No headers' do
      before { delete "/api/v1/pets/#{pet.id}" }

      it 'returns unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'PET DELETE - Trying to access another user pet' do
      before { delete "/api/v1/pets/#{pet.id}", headers: header_no_pets }

      it 'responds with :ok for a valid request' do
        expect(response).to have_http_status(:ok)
      end

      it 'has message for not authorized' do
        result = JSON.parse(response.body).dig('pet')
        expect(result).to eq('Not Found')
      end
    end
  end
end
