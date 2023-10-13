require 'rails_helper'

RSpec.describe Lecture, type: :model do
  describe 'validations' do
    it 'is valid with a unique title' do
      lecture = create(:lecture, title: 'Unique Title')
      expect(lecture).to be_valid
    end

    it 'is not valid with a non-unique title' do
      create(:lecture, title: 'Not Unique Title')
      lecture = build(:lecture, title: 'Not Unique Title')
      expect(lecture).to be_invalid
      expect(lecture.errors[:title]).to include('has already been taken')
    end
  end
end
