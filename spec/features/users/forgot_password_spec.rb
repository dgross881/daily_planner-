require 'spec_helper'

feature "Forgotten passwords" do
  let!(:user) { create(:user) } 

  scenario "It sends user an email" do
    visit login_path
    click_link "Forgot Password"
    fill_in "Email", with: user.email
    expect {
      click_button "Reset Password"
    }.to change{ActionMailer::Base.deliveries.size}.by(1)
  end
  
  scenario "resets a password when following the email link" do
    visit login_path
    click_link "Forgot Password"
    fill_in "Email", with: user.email
    click_button "Reset Password"
    open_email(user.email)
    current_email.click_link "http://"
    expect(page).to have_selector("h2","Reset Password")

    fill_in "Password", with: "mynewpassword1"
    fill_in "Password(again)", with: "mynewpassword1"
    click_button "Change Password"
    expect(page).to have_content("Your password has been updated")
    expect(page.current_path).to eq(todo_lists_path)
    
    click_link "Sign Out"
    expect(page).to have_content("You have been logged out")
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "mynewpassword1"
    click_button "Sign In"
    expect(page).to have_content("Thanks for logging in!")
  end
end
