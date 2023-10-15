class OrganizeTracksService
  def initialize(lectures)
    @alphabet_index = ('A'..'Z').to_a
    @minutes_in_hours = {
      '9:00' => 540, '12:00' => 720, '13:00' => 780, '15:00' => 900, '16:00' => 960, '17:00' => 1020
    }
    @coffee_break = {
      'lunch' => { 'hour' => '12:00', 'title' => 'Almoço', 'duration' => '' },
      'network' => { 'hour' => '17:00', 'title' => 'Evento de NetWork', 'duration' => '' }
    }
    @count_track = 0
    @track = @alphabet_index[@count_track]

    morning_duration = @minutes_in_hours['12:00'] - @minutes_in_hours['9:00']
    afternoon_duration = @minutes_in_hours['17:00'] - @minutes_in_hours['13:00']
    @lectures = organize_lectures(lectures, [morning_duration, afternoon_duration])
  end

  def run
    create_tracks
  end

  private

  def create_tracks
    current_minutes = @minutes_in_hours['9:00']

    schedules_array = []
    @lectures.each do |item|
      schedules = formatted_duration(current_minutes)
      only_numbers_from_minutes = item[:duration]

      current_minutes, schedules_array = process_item(item, @track, current_minutes, only_numbers_from_minutes, schedules, schedules_array)
    end

    add_networking_event_if_needed(@track, schedules_array)

    { organize: true, data: schedules_array }
  rescue StandardError
    { error: 'Erro ao Organizar Horários.', organize: false }
  end

  def process_item(item, track, current_minutes, only_numbers_from_minutes, schedules, schedules_array)
    case
    when lunch_break?(current_minutes)
      current_minutes, schedules_array = handle_lunch_break(item, track, schedules_array)
    when networking_event?(current_minutes)
      current_minutes, schedules_array = handle_networking_event(item, track, schedules_array)
    else
      current_minutes, schedules_array = handle_default(item, track, current_minutes, schedules, schedules_array, only_numbers_from_minutes)
    end
    [current_minutes, schedules_array]
  end

  def lunch_break?(current_minutes)
    current_minutes == @minutes_in_hours['12:00'] && current_minutes <= @minutes_in_hours['13:00']
  end

  def networking_event?(current_minutes)
    current_minutes >= @minutes_in_hours['17:00']
  end

  def add_event(schedules_array, schedule, title, duration, track, id = nil)
    event = {
      schedule: schedule,
      title: title,
      duration: duration,
      track: track
    }
    event[:id] = id if id

    schedules_array << event
  end

  def handle_default(item, track, current_minutes, schedules, schedules_array, only_numbers_from_minutes)
    add_event(schedules_array, schedules, item[:title], item[:duration], track, item[:id])
    current_minutes += only_numbers_from_minutes
    [current_minutes, schedules_array]
  end

  def handle_lunch_break(item, track, schedules_array)
    add_event(schedules_array, @coffee_break['lunch']['hour'], @coffee_break['lunch']['title'], @coffee_break['lunch']['duration'], track)
    new_current_minutes = @minutes_in_hours['13:00']
    add_event(schedules_array, '13:00', item[:title], item[:duration], track, item[:id])
    new_current_minutes += item[:duration]
    [new_current_minutes, schedules_array]
  end

  def handle_networking_event(item, track, schedules_array)
    old_minutes = item[:duration]
    old_title = item[:title]
    new_schedules = @coffee_break['network']['hour']
    new_title = @coffee_break['network']['title']
    new_minutes = @coffee_break['network']['duration']
    id = item[:id]

    schedules_array << {
      schedule: new_schedules,
      title: new_title,
      duration: new_minutes,
      track: track
    }

    @count_track += 1
    @track = @alphabet_index[@count_track]

    new_current_minutes = @minutes_in_hours['9:00']

    schedules_array << { schedule: formatted_duration(new_current_minutes), title: old_title, duration: old_minutes, track: @track, id: id }

    new_current_minutes += old_minutes
    [new_current_minutes, schedules_array]
  end

  def add_networking_event_if_needed(track, schedules_array)
    add_event(schedules_array, @coffee_break['network']['hour'], @coffee_break['network']['title'], @coffee_break['network']['duration'], track)
  end

  def formatted_duration(total_minute)
    hours = total_minute / 60
    minutes = "#{(total_minute) % 60}"
    formatHours = hours.to_s.length < 2 ? "0#{hours}" : hours
    formatMinutes = minutes.split('min')[0].to_i == 0 ? '00' : minutes

    "#{ formatHours }:#{ formatMinutes }".strip
  end

  def find_hours_combination(itens, minute_sum)
    return [] if minute_sum <= 0
    return nil if itens.empty?

    first_data = itens[0]
    return [first_data] if first_data['duration'].to_i == minute_sum

    combination_without_first = find_hours_combination(itens[1..-1], minute_sum)
    combination_with_first = find_hours_combination(itens[1..-1], minute_sum - first_data['duration'].to_i)
    combination_with_first << first_data if combination_with_first

    if combination_with_first.nil?
      combination_without_first
    elsif combination_without_first.nil?
      combination_with_first
    else
      combination_without_first.length < combination_with_first.length ? combination_without_first : combination_with_first
    end
  end

  def organize_lectures(lectures_base, minutes)
    lectures = []

    until lectures_base.empty?
      minutes.each do |minute|
        break if lectures_base.empty?

        lactures_ordened = find_hours_combination(lectures_base, minute)
        lectures += (lactures_ordened.nil? ? lectures_base : lactures_ordened.sort_by { |lacture| lacture[:id] })
        lectures_base = lectures_base.reject { |element| lectures.include?(element) }
      end
    end
    lectures
  end
end
