require 'rails_helper'

RSpec.describe "Sign_ups", type: :system do
  include ActiveJob::TestHelper

  # ユーザーはサインアップに成功する
  scenario "user successfully sings up" do
    visit root_path
    click_link "Sign up"

    perform_enqueued_jobs do
      expect {
        fill_in "First name", with: "First"
        fill_in "Last name", with: "Last"
        fill_in "Email", with: "test@example.com"
        fill_in "Password", with: "test1234"
        fill_in "Password confirmation", with: "test1234"
        click_button "Sign up"
      }.to change(User, :count).by(1)

      mail = ActionMailer::Base.deliveries.last

      aggregate_failures do
        expect(mail.to).to eq ["test@example.com"]
        expect(mail.from).to eq ["support@example.com"]
        expect(mail.subject).to eq "Welcome to Projects!"
        expect(mail.body).to match "Hello First,"
        expect(mail.body).to match "test@example.com"
      end
    end
  end
end