require "application_system_test_case"

class VacationsTest < ApplicationSystemTestCase
  setup do
    @vacation = vacations(:one)
  end

  test "visiting the index" do
    visit vacations_url
    assert_selector "h1", text: "Vacations"
  end

  test "creating a Vacation" do
    visit vacations_url
    click_on "New Vacation"

    fill_in "End date", with: @vacation.end_date
    fill_in "Start date", with: @vacation.start_date
    fill_in "User", with: @vacation.user_id
    click_on "Create Vacation"

    assert_text "Vacation was successfully created."
    click_on "Back"
  end

  test "updating a Vacation" do
    visit vacations_url
    click_on "Edit it", match: :first

    fill_in "End date", with: @vacation.end_date
    fill_in "Start date", with: @vacation.start_date
    fill_in "User", with: @vacation.user_id
    click_on "Update Vacation"

    assert_text "Vacation was successfully updated."
    click_on "Back"
  end

  test "destroying a Vacation" do
    visit vacations_url
    page.accept_confirm do
      click_on "Destroy it", match: :first
    end

    assert_text "Vacation was successfully destroyed."
  end
end
