require 'rails_helper'

RSpec.describe LectureImportService do
  describe '#import' do
    it 'imports lectures from a CSV file' do
      csv_data = "Title,Duration\nLecture_1, 60Min\nLecture_2, 30Min\nLecture_3, 45Min\n"

      file = Tempfile.new(['lecture_data', '.csv'])
      file.write(csv_data)
      file.rewind

      service = LectureImportService.new
      service.import(file)
      expect(Lecture.count).to eq(3)

      expect(Lecture.pluck(:title)).to eq ["Lecture_1", "Lecture_2", "Lecture_3"]
      expect(Lecture.pluck(:duration)).to eq [60, 30, 45]

      file.close
      file.unlink
    end
  end
end
