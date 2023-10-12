class Api::V1::LecturesController < Api::V1::ApiController
  protect_from_forgery with: :null_session 
  # protect_from_forgery estou setando essa informação, apenas para facilitar o teste
  # caso fosse um ambiente real de prod isso nunca seria feito assim.

  def create_lectures
    data = JSON.parse(request.body.read)
    created_lectures = []
    errors = []
    data_formated = ExtractSchedulesService.new(data).extract

    data_formated.each do |entry|
      lecture = Lecture.new(title: entry[:title], duration: entry[:duration])
      if lecture.save
        created_lectures << lecture
      else
        errors << "Erro ao criar palestra: #{lecture.errors.full_messages.join(', ')}"
      end
    end

    response = {
      created_lectures: created_lectures,
      errors: errors
    }

    render json: response, status: :ok
  rescue JSON::ParserError
    render json: { error: 'JSON inválido' }, status: :unprocessable_entity
  end

  def organize_event
    @lectures = Lecture.all

    @tracks = OrganizeTracksService.new(@lectures).organize_tracks

    if @tracks[:organize]
      render json: @tracks[:data] || [], status: 200
    else
      render json: { error: @tracks[:error] }, status: 500
    end
  end
end
