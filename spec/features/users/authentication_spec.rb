require "spec_helper"

describe "Loggin In" do
  it "logs the user in when pw and email is correct and goes to the todo lists" do
    User.create(first_name: "David", last_name: "Gross", email: "dgross881@gmail.com", password: "foobar", password_confirmation: "foobar") 
    visit new_user_session_path
    fill_in "Email Address", with: "dgross881@gmail.com"
    fill_in "Password", with: "foobar"
    click_button "Log In" 

    expect(page).to have_content("Todo Lists") 
    expect(page).to have_content("Thanks for logging in") 
  end
  
  it "still displays the email address in the event of a failed login" do 
    visit new_user_session_path
    fill_in "Email Address", with: "dgross881@gmail.com"
    fill_in "Password", with: "wrong password"
    click_button "Log In" 

    expect(page).to have_content("Error please try again") 
    expect(page).to have_field("Email Address", with: "dgross881@gmail.com") 
  end 
end
