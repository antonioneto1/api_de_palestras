class ExtractSchedulesService
  def initialize(data)
    @data_lactures = data
    @custom_duration = { 'lightning' => '05min' }
  end

  def extract
    extract_schedules
  end

  private

  def extract_schedules
    data_lactures_formatted = []

    @data_lactures.each do |row|
      title = row.dig("title")
      duration = extract_duration(row)

      data_lactures_formatted << { title: title, duration: duration }
    end

    data_lactures_formatted
  end

  def extract_duration(row)
    duration = row.dig("duration")

    return 5 if duration.to_s.downcase == 'lightning'

    minutes = duration.to_i
    return minutes if minutes > 0

    duration.gsub!(/[^0-9]/, '')
    duration.to_i
  end
end
