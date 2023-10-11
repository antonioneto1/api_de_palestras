class ExtractSchedulesService
  def initialize(schedules_array)
    @timesheet = schedules_array
    @custom_duration = { 'lightning' => '05min' }
  end

  def extract
    extract_schedules
  end

  private

  def extract_schedules
    timesheet_formatted = []

    @timesheet.each do |row|
      description = extract_description(row)
      minutes = extract_minutes(row)

      timesheet_formatted.push({ description: description, minutes: minutes })
    end

    timesheet_formatted
  end

  def extract_description(row)
    row.gsub(/\s+/, " ").strip.match(/.*[\D]+?\s/).to_s
  end

  def extract_minutes(row)
    minutes_match = row.strip.match(/[\d]+min$|[\d]+(\s)min$/).to_s.delete(' ')
    minutes_match.empty? ? @custom_duration['lightning'] : minutes_match
  end
end
