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

    return [] if @lectures.empty?

    @tracks = OrganizeTracksService.new(@lectures).run

    respond_to do |format|
      format.json { render json: @tracks }
    end
  end

  def destroy_multiple
    lecture_ids = params[:lecture_ids]
    if lecture_ids.present?
      valid_ids = Lecture.where(id: lecture_ids).pluck(:id)

      if valid_ids.present?
        Lecture.where(id: valid_ids).destroy_all
        render json: { message: 'Palestras excluídas com sucesso' }, status: :ok
      else
        render json: { error: 'Nenhum ID de palestra válido fornecido' }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Nenhum ID de palestra fornecido' }, status: :unprocessable_entity
    end
  end

  def update_multiple
    lecture_updates = params[:lecture_updates]

    if lecture_updates.present?
      lecture_updates.each do |update_params|
        lecture = Lecture.find(update_params[:id])
        lecture.update(update_params.slice(:title, :duration))
      end

      render json: { message: 'Palestras atualizadas com sucesso' }, status: :ok
    else
      render json: { error: 'Nenhum dado de atualização fornecido' }, status: :bad_request
    end
  end
end
