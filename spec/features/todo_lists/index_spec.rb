require 'spec_helper'

describe "Listing todo lists"  do
  it "requires log" do
    visit '/todo_lists'
    expect(page).to have_content("You must be logged in") 
  end
end
