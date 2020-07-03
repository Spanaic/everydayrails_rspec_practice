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
  #   visit root_path
  #   click_link "New Project"
  # end

  # ユーザーはプロジェクトを完了済みにする
  scenario "user completes a project" do
    # プロジェクトを持ったユーザーを準備する
    user = FactoryBot.create(:user)
    project = FactoryBot.create(:project, owner: user)
    # ユーザーはログインしている
    sign_in user
    # ユーザーがプロジェクト画面を開き、
    visit project_path(project)

    # complete前は"Completed"ラベルを表示しない
    expect(page).to_not have_content "Completed"

    # "complete"ボタンをクリックすると
    click_button "Complete"

    # FIXME: launchyがdocker上でうまく動かず...
    # save_and_open_page

    # プロジェクトは完了済みとしてマークされる
    expect(project.reload.completed?).to be true
    expect(page).to \
      have_content "Congratulations, this project is complete!" # flash
    expect(page).to have_content "Completed"
    expect(page).to_not have_button "Complete"
  end
end
