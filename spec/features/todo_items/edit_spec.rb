require 'spec_helper'

feature "Editing todo items" do 
 let(:user) { create(:user) }
 let!(:todo_list)  { create(:todo_list) }  
 let!(:todo_item) {todo_list.todo_items.create(content: "Push ups") } 
 before { sign_in todo_list.user, password: "treehouse1" }
  
  scenario "is successful with valid content" do 
    visit_todo_list(todo_list)
   within("#todo_item_#{todo_item.id}") do 
     click_link todo_item.content
   end 
  
   fill_in "Content", with: "Lots of Pushups"
   click_button "Save"
   expect(page).to have_content("Saved todo list item")
   todo_item.reload
   expect(todo_item.content).to eq("Lots of Pushups") 
 end 

  scenario "is unsuccessful with valid content" do 
    visit_todo_list(todo_list)
    within("#todo_item_#{todo_item.id}") do 
     click_link todo_item.content
   end 
  
   fill_in "Content", with: ""
   click_button "Save"
   expect(page).to_not have_content("Saved todo list item")
   expect(page).to have_content(/Can't be blank/)
   todo_item.reload 
   expect(todo_item.content).to eq("Push ups")
 end 
end 
