require 'spec_helper' 

feature "Signin up" do
  scenario "allows a user to sign up for the site and creates the object in the database" do
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

  scenario "displays a tutorial when th user signs up" do 
  visit "/"
  expect(page).to have_content("Sign Up")    
  click_link "Sign Up"
  fill_in "First Name", with: "David"
  fill_in "Last Name", with: "Gross"
  fill_in "Email", with: "dgross881@gmail.com"
  fill_in "Password", with: "foobar" 
  fill_in "Password(again)", with: "foobar"
  click_button "Sign Up"
  expect(page).to have_content("Daily Planner Tutorial")

  click_on "Daily Planner Tutorial"
  expect(page.all("li.todo-item").size).to eq(7)
 end 
end
