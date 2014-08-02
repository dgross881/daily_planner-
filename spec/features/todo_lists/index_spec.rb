require 'spec_helper'

feature "Listing todo lists"  do
  it "requires log" do
    visit '/todo_lists'
    expect(page).to have_content("You must be logged in") 
  end
end
