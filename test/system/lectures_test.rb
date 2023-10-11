require "application_system_test_case"

class LecturesTest < ApplicationSystemTestCase
  setup do
    @lecture = lectures(:one)
  end

  test "visiting the index" do
    visit lectures_url
    assert_selector "h1", text: "Lectures"
  end

  test "should create lecture" do
    visit lectures_url
    click_on "New lecture"

    fill_in "Duration", with: @lecture.duration
    fill_in "Title", with: @lecture.title
    click_on "Create Lecture"

    assert_text "Lecture was successfully created"
    click_on "Back"
  end

  test "should update Lecture" do
    visit lecture_url(@lecture)
    click_on "Edit this lecture", match: :first

    fill_in "Duration", with: @lecture.duration
    fill_in "Title", with: @lecture.title
    click_on "Update Lecture"

    assert_text "Lecture was successfully updated"
    click_on "Back"
  end

  test "should destroy Lecture" do
    visit lecture_url(@lecture)
    click_on "Destroy this lecture", match: :first

    assert_text "Lecture was successfully destroyed"
  end
end
