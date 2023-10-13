require 'rails_helper'

RSpec.describe LecturesController, type: :controller do
  describe 'GET #index' do
    it 'assigns all lectures as @lectures' do
      lecture1 = create(:lecture, title: 'Lecture 1', duration: 60)
      lecture2 = create(:lecture, title: 'Lecture 2', duration: 45)
      lecture3 = create(:lecture, title: 'Lecture 3', duration: 30)

      get :index
      expect(assigns(:lectures)).to eq([lecture1, lecture2, lecture3])
    end

    it 'assigns an error message to @error if service returns an error' do
      allow(OrganizeTracksService).to receive_message_chain(:new, :run).and_return({ organize: false})

      get :index
      expect(assigns(:error)).to eq(nil)
    end
  end
end
