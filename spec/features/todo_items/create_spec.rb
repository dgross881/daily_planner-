require 'spec_helper' 

describe "Createing todo items" do
  let!(:todo_list) { TodoList.create!(title: "Daves Worout", description: "Monday the workouts begin") } 

  def visit_todo_list(list)
    visit '/todo_lists'
    within "#todo_list_#{todo_list.id}" do 
     click_link "List Items"
    end 
  end 

  it "is successful with valid content" do 
    visit_todo_list(todo_list) 
    click_link "New Todo Item"
    fill_in "Content", with: "Milk"
    click_button "Save" 
    expect(page).to have_content("Added todo list item")
    within("ul.todo_items") do
      expect(page).to have_content("Milk")
   end 
  end 
 
 it "displays an error with no content" do 
   visit_todo_list(todo_list)
   click_link "New Todo Item" 

   fill_in "Content", with: ""
   click_button "Save" 
    
   within("div.flash") do
     expect(page).to have_content("List item did not save")
   end 
     expect(page).to have_content("Content can't be blank")
  end 

  it "displays an error with content too short" do 
   visit_todo_list(todo_list)
   click_link "New Todo Item" 

   fill_in "Content", with: "hi"
   click_button "Save" 
   expect(page).to have_content("Content is too short")
  end 
end

