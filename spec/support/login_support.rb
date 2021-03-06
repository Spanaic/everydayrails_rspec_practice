module LoginSupport
  def sign_in_as(user)
    visit root_path
    click_link "Sign in"
    fill_in "user[email]", with: user.email
    fill_in "user[password]", with: user.password
    click_button "Log in"
  end
end

RSpec.configure do |config|
  config.include LoginSupport
end