require 'spec_helper'

feature "Adding todo items" do
  let(:user) { create(todo_list.user) }
  let!(:todo_list)  { create(:todo_list) } 
  
  before do 
   sign_in todo_list.user, password: "treehouse1"
  end 

  scenario "is successful with valid content" do
    visit_todo_list(todo_list)
    click_link "Add Todo Item"
    fill_in "Content", with: "Milk"
    click_button "Save"
    expect(page).to have_content(/Added todo list item./)
    within(".todo-items") do
      expect(page).to have_content("Milk")
    end
  end

  scenario "displays an error with no content" do
    visit_todo_list(todo_list)
    click_link "Add Todo Item"
    fill_in "Content", with: ""
    click_button "Save"
    within("div.flash") do
      expect(page).to have_content("There was a problem adding that todo list item.")
    end
    expect(page).to have_content(/Can't be blank/)
  end

  scenario "displays an error with content less than 2 characters long" do
    visit_todo_list(todo_list)
    click_link "Add Todo Item"
    fill_in "Content", with: "1"
    click_button "Save"
    within("div.flash") do
      expect(page).to have_content("There was a problem adding that todo list item.")
    end
    expect(page).to have_content(/Is too short/)
  end
  
end
