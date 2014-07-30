require 'spec_helper'

describe "Editing todo items" do 
  let(:user) {create(:user) }
  let!(:todo_list) {TodoList.create(title: "Daves Workdout", description: "Friday it begins") } 
  let!(:todo_item) {todo_list.todo_items.create(content: "Push ups") } 

  before do 
   sign_in user, password: "treehouse1"
  end 
  
  it "is successful with valid content" do 
    visit_todo_list(todo_list)
   within("#todo_item_#{todo_item.id}") do 
     click_link "Edit"
   end 
  
   fill_in "Content", with: "Lots of Pushups"
   click_button "Save"
   expect(page).to have_content("Saved todo list item")
   todo_item.reload
   expect(todo_item.content).to eq("Lots of Pushups") 
 end 

  it "is unsuccessful with valid content" do 
    visit_todo_list(todo_list)
    within("#todo_item_#{todo_item.id}") do 
     click_link "Edit"
   end 
  
   fill_in "Content", with: ""
   click_button "Save"
   expect(page).to_not have_content("Saved todo list item")
   expect(page).to have_content("Content can't be blank")
   todo_item.reload 
   expect(todo_item.content).to eq("Push ups")
 end 
end 
