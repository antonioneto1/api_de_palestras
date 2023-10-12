class LecturesController < ApplicationController
  before_action :set_lecture, only: %i[show edit update destroy]

  def index
    @lectures = Lecture.all
    organized_tracks = OrganizeTracksService.new(@lectures).organize_tracks

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
    # Lógica para importação de CSV aqui
    # Certifique-se de que o arquivo CSV seja processado e as palestras sejam criadas no banco de dados
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
