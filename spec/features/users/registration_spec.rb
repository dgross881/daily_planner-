require 'spec_helper' 

describe "Signin up" do
  it "allows a user to sign up for the site and creates the object in the database" do
  expect(User.count).to eq(0) 

  visit "/"
  expect(page).to have_content("Sign Up")    
  click_link "Sign Up"
  fill_in "First Name", with: "David"
  fill_in "Last Name", with: "Gross"
  fill_in "Email", with: "dgross881@gmail.com"
  fill_in "Password", with: "foobar" 
  fill_in "Password(again)", with: "foobar"
  expect(User.count).to eq(0)
  end
end
