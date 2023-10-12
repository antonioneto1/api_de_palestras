class OrganizeTracksService

  def initialize(lectures)
    @lectures = lectures
    @alphabet_index = ('A'..'Z').to_a
    @minutes_in_hours = {
      '9h' => 540, '12h' => 720, '13h' => 780, '15h' => 900, '16h' => 960, '17h' => 1020
    }
    @coffee_break = {
      'lunch' => { 'hour' => '12h', 'title' => 'almoço', 'duration' => 60 },
      'network' => { 'hour' => '17h', 'title' => 'Evento de netWork', 'duration' => '' }
    }
    @count_track = 0
    @track = @alphabet_index[@count_track]
  end

  # 540 de até 720 são 180
  # 780 de até 1020 são 240

  def organize_tracks
    current_minutes = @minutes_in_hours['9h']

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

  private

  def process_item(item, track, current_minutes, only_numbers_from_minutes, schedules, schedules_array)
    if current_minutes == @minutes_in_hours['12h'] && current_minutes <= @minutes_in_hours['13h']
      current_minutes, schedules_array = handle_lunch_break(item, track, current_minutes, schedules, schedules_array)
    elsif current_minutes >= @minutes_in_hours['17h']
      current_minutes, track, schedules_array = handle_networking_event(item, track, current_minutes, schedules_array)
    else
      schedules_array << {
                            schedule: schedules,
                            title: item[:title],
                            duration: item[:duration],
                            track: track
                          }

      current_minutes += only_numbers_from_minutes
    end
    [current_minutes, schedules_array]
  end

  def handle_lunch_break(item, track, current_minutes, schedules, schedules_array)
    old_schedules = schedules
    old_title = item[:title]
    old_minutes = item[:duration]
    new_schedules = @coffee_break['lunch']['hour']
    new_title = @coffee_break['lunch']['title']
    new_minutes = @coffee_break['lunch']['duration']

    schedules_array << {
                        schedule: new_schedules,
                        title: new_title,
                        duration: new_minutes,
                        track: track
                      }

    current_minutes = @minutes_in_hours['13h']

    schedules_array << {
                        schedule: formatted_duration(@minutes_in_hours['13h']),
                        title: old_title,
                        duration: old_minutes,
                        track: track
                      }

    current_minutes += old_minutes
    [current_minutes, schedules_array]
  end

  def handle_networking_event(item, track, current_minutes, schedules_array)
    old_minutes = item[:duration]
    old_title = item[:title]
    new_schedules = @coffee_break['network']['hour']
    new_title = @coffee_break['network']['title']
    new_minutes = @coffee_break['network']['duration']

    schedules_array << {
                        schedule: new_schedules,
                        title: new_title,
                        duration: new_minutes,
                        track: track
                      }

    @count_track += 1

    @track = @alphabet_index[@count_track]

    current_minutes = @minutes_in_hours['9h']

    schedules_array << { schedule: formatted_duration(current_minutes), title: old_title, duration: old_minutes, track: @track }

    current_minutes += old_minutes
    [current_minutes, @track, schedules_array]
  end

  def add_networking_event_if_needed(track, schedules_array)
    schedules_array << {
                          schedule: @coffee_break['network']['hour'],
                          title: @coffee_break['network']['title'],
                          duration: @coffee_break['network']['duration'],
                          track: track
                        }
  end

  def formatted_duration(total_minute)
    hours = total_minute / 60
    minutes = "#{(total_minute) % 60}"
    formatHours = hours.to_s.length < 2 ? "0#{hours}" : hours
    formatMinutes = minutes.split('min')[0].to_i == 0 ? '00' : minutes

    "#{ formatHours }:#{ formatMinutes }".strip
  end
end
