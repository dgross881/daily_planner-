require "spec_helper"

feature "Loggin In" do
  scenario "logs the user in when pw and email is correct and goes to the todo lists" do
    User.create(first_name: "David", last_name: "Gross", email: "dgross881@gmail.com", password: "foobar", password_confirmation: "foobar") 
    visit new_user_session_path
    fill_in "Email Address", with: "dgross881@gmail.com"
    fill_in "Password", with: "foobar"
    click_button "Log In" 

    expect(page).to have_content("Thanks for logging in!") 
    expect(page).to have_selector("h2", "Todo lists")
  end
  
  it "still displays the email address in the event of a failed login" do 
    visit new_user_session_path
    fill_in "Email Address", with: "dgross881@gmail.com"
    fill_in "Password", with: "wrong password"
    click_button "Log In" 

    expect(page).to have_content("Please check your email and password") 
    expect(page).to have_field("Email Address", with: "dgross881@gmail.com") 
  end 
end
