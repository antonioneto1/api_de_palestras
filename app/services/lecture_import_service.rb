class LectureImportService
  require 'csv'

  def import(file)
    lactures_data = CSV.read(file.path, headers: true)

    create_lactures(lactures_data)
  rescue StandardError => e
    { success: false, error_message: e.message }
  end

  def create_lactures(lactures_data)
    lactures_data.each do |row|
      Lecture.create(title: row[0], duration: extract_duration(row[1]))
    end
  end

  def extract_duration(duration)
    return 5 if duration.to_s.downcase == 'lightning'

    minutes = duration.to_i
    return minutes if minutes > 0

    duration.gsub!(/[^0-9]/, '')
    duration.to_i
  end
end
