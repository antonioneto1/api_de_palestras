class LecturesController < ApplicationController
  require 'csv'
  before_action :set_lecture, only: %i[show edit update destroy]

  def index
    @lectures = Lecture.all

    return [] if @lectures.empty?

    organized_tracks = OrganizeTracksService.new(@lectures).run

    if organized_tracks[:organize]
      organized_data = {}

      organized_tracks[:data].each do |item|
        track = item[:track]
        organized_data[track] ||= []
        organized_data[track] << item
      end

      @tracks = organized_data
    else
      @error = organized_tracks[:error]
    end
  end

  # GET /lectures/1 or /lectures/1.json
  def show
  end

  # GET /lectures/new
  def new
    @lecture = Lecture.new
  end

  def import_csv
    uploaded_file = params[:file]

    if uploaded_file.nil?
      flash[:alert] = "Selecione um arquivo CSV para importar."
      redirect_to import_lectures_path
      return
    end

    if uploaded_file.content_type != 'text/csv'
      flash[:alert] = "Selecione um arquivo CSV válido."
      redirect_to import_lectures_path
      return
    end

    service = LectureImportService.new
    result = service.import(uploaded_file)

    if result[:success]
      flash[:notice] = "#{result[:created_count]} palestras criadas com sucesso!"
    else
      flash[:alert] = "Ocorreram erros durante a importação."
    end
    redirect_to lectures_path
  rescue StandardError => e
    flash[:alert] = "Ocorreu um erro durante a importação: #{e.message}"
  end

  # GET /lectures/1/edit
  def edit
  end

  def create
    @lecture = Lecture.new(lecture_params)

    respond_to do |format|
      if @lecture.save
        format.html { redirect_to lecture_url(@lecture), notice: "Lecture was successfully created." }
        format.json { render :show, status: :created, location: @lecture }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lecture.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @lecture.update(lecture_params)
        format.html { redirect_to lecture_url(@lecture), notice: "Lecture was successfully updated." }
        format.json { render :show, status: :ok, location: @lecture }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lecture.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @lecture.destroy

    respond_to do |format|
      format.html { redirect_to lectures_url, notice: "Lecture was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_lecture
    @lecture = Lecture.find(params[:id])
  end

  def lecture_params
    params.require(:lecture).permit(:title, :duration)
  end
end
