require 'spec_helper'
feature "Editing todo lists"do
  let(:user) { todo_list.user } 
  let!(:todo_list)  { create(:todo_list) }  
  
 before do 
  sign_in user, password: "treehouse1"
 end 
 
  scenario "is succesful when clicking destory link"  do 
  pending "Until delete  button is added to index todo list"
   visit "/todo_lists"

   within "#todo_list_#{todo_list.id}" do
    	click_link "Destroy"
   end 
   expect(page).to_not have_content(todo_list.title)
   expect(TodoList.count).to eq(0)
  end
end 
