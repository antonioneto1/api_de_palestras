class EventImporterService
  require 'csv'

  def self.import(file)
    begin
      events_data = CSV.read(file.path, headers: true)

      event = Event.create(name: 'Minha Conferência')

      organize_event(event, events_data)

      { success: true }
    rescue StandardError => e
      { success: false, error_message: e.message }
    end
  end

  def self.organize_event(event, events_data)
    morning_session = event.sessions.create(name: 'Manhã', start_time: '9:00 AM', end_time: '12:00 PM')
    afternoon_session = event.sessions.create(name: 'Tarde', start_time: '1:00 PM', end_time: '4:00 PM')

    current_time = Time.parse(morning_session.start_time)

    events_data.each do |row|
      name = row['Nome da palestra']
      duration = parse_duration(row['Duração'])
      talk = Talk.create(name: name, duration: duration)

      if current_time < Time.parse(morning_session.end_time)
        morning_session.talks << talk
      else
        afternoon_session.talks << talk
      end

      current_time += duration.minutes
    end

    create_networking_session(event, afternoon_session.end_time)
  end

  def self.parse_duration(duration)
    duration == 'lightning' ? 5 : duration.to_i
  end

  def self.create_networking_session(event, end_time)
    start_time = end_time < '16:00 PM' ? '4:00 PM' : '5:00 PM'
    event.sessions.create(name: 'Networking', start_time: start_time, end_time: '5:00 PM')
  end
end
