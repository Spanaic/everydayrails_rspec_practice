require 'rails_helper'

RSpec.describe "Projects", type: :system do

  # ユーザーは新しいプロジェクトを作成する
  scenario "user creates a new project" do
    user = FactoryBot.create(:user)
    sign_in_as user
    # sign_in_as user

    visit root_path
    # click_link "Sign in"
    # fill_in "Email", with: user.email
    # fill_in "Password", with: user.password
    # click_button "Log in"

    expect {
      click_link "New Project"
      fill_in "Name", with: "Test Project"
      fill_in "Description", with: "Trying ut Capybara"
      click_button "Create Project"
    }.to change(user.projects, :count).by(1)

      aggregate_failures do
        expect(page).to have_content "Project was successfully created"
        expect(page).to have_content "Test Project"
        expect(page).to have_content "Owner: #{user.name}"
      end
  end

  # ゲストがプロジェクトを追加する
  # scenario "guest adds a project" do
  #   visit projects_path
  #   click_link "New Project"
  # end
end
