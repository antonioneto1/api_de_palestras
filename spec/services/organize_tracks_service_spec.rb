require 'rails_helper'

RSpec.describe OrganizeTracksService do
  describe '#run' do
    it 'organizes lectures into tracks' do
      lecture1 = create(:lecture, title: 'Lecture 1', duration: 60)
      lecture2 = create(:lecture, title: 'Lecture 2', duration: 30)
      lecture3 = create(:lecture, title: 'Lecture 3', duration: 45)
      lecture4 = create(:lecture, title: 'Lecture 4', duration: 60)
      lecture5 = create(:lecture, title: 'Lecture 5', duration: 45)

      lectures = [lecture1, lecture2, lecture3, lecture4, lecture5]
      service = OrganizeTracksService.new(lectures)
      result = service.run

      expect(result[:organize]).to be true
      organized_data = result[:data]
      expect(organized_data).not_to be_empty
    end
  end
end
