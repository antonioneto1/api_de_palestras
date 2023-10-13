require 'rails_helper'

RSpec.describe Api::V1::LecturesController, type: :controller do
  describe 'POST #create_lectures' do
    it 'creates lectures from valid JSON data' do
      valid_json = [
        { title: 'Lec 1', duration: 60 },
        { title: 'Lec 2', duration: 45 }
      ].to_json

      post :create_lectures, body: valid_json

      expect(response).to have_http_status(:ok)
      response_data = JSON.parse(response.body)

      expect(response_data['created_lectures'].count).to eq(2)
    end

    it 'handles invalid JSON data' do
      invalid_json = 'Invalid JSON'

      post :create_lectures, body: invalid_json

      expect(response).to have_http_status(:unprocessable_entity)

      response_data = JSON.parse(response.body)
      expect(response_data['error']).to eq('JSON inválido')
    end
  end

  describe 'GET #organize_event' do
    it 'organizes lectures into tracks' do
      get :organize_event, format: :json
      expect(response).to have_http_status(:no_content)
    end
  end
end
