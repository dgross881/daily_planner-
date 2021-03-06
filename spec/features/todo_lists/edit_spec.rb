require 'spec_helper'

feature "Editing todo lists"  do
 let(:user) { create(:user) }
 let!(:todo_list)  { create(:todo_list) }  
 
 before do 
   sign_in todo_list.user, password: "treehouse1"
 end 
 
 def update_todo_list(options={})
    options[:title] ||= "Workout Plan" 
    todo_list ||= options[:todo_list]
    
    visit "/todo_lists"
      click_link todo_list.title 
      click_link "Edit"
    fill_in "Title", with: options[:title]
    click_button "Save"
  end  

 scenario 'updates todo list successfully with correct information' do
  visit '/todo_lists'
  click_on todo_list.title
  update_todo_list todo_list: todo_list   
  todo_list.reload

  expect(page).to have_content("Todo list was successfully updated") 
  expect(todo_list.title).to eq("Workout Plan")
 end 

 scenario "displays an error with no title" do 
  update_todo_list todo_list: todo_list, title:''

  title = todo_list.title
  todo_list.reload
  expect(todo_list.title).to eq(title)
  expect(page).to have_content(/Can't be blank/i)
 end 
 
 scenario "displays an error with too short title" do 
   update_todo_list todo_list: todo_list, title:'hi'
 title = todo_list.title
 todo_list.reload
 expect(todo_list.title).to eq(title)
 expect(page).to have_content(/is too short/i)
 end
end

