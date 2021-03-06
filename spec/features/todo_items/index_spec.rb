require 'spec_helper'

feature "Viewing todo items" do
 let(:user) { create(:user) }
 let!(:todo_list)  { create(:todo_list) }  
 before { sign_in todo_list.user, password: "treehouse1" }
  
  scenario "displays the title of the todo_list" do 
    visit_todo_list(todo_list)
     first("h2.page-title") do 
      expect(page).to have_content(todo_list.title)
    end 
  end

  scenario "displays no item when a todo list is empty" do
    visit_todo_list(todo_list)
    expect(page.all(".todo-items td").count).to eq(0)
  end 

  scenario "displays item content when a todo list has items" do 
    todo_list.todo_items.create(content: "Milk") 
    todo_list.todo_items.create(content: "Eggs")

    visit_todo_list(todo_list)
    expect(todo_list.todo_items.count).to eq(2)
    
    within ".todo-items" do 
       expect(page).to have_content("Milk")
       expect(page).to have_content("Eggs")
    end 
  end 
end 
