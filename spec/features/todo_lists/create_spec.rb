require 'spec_helper' 

describe "Creating todo lists" do
  def create_todo_list(options={})
    options[:title] ||= "Daves weekly planner"
    options[:description] ||= "On Monday the workouts begin"
    
    visit "/todo_lists"
    click_link "New Todo list" 
    fill_in "Title", with: options[:title] 
    fill_in "Description", with: options[:description]
    click_button "Create Todo list"  
  end

  it "redirects to the todo list index page on success" do 
    visit "/todo_lists" 
    expect(page).to have_content("New Todo list")
   
    create_todo_list
    expect(page).to have_content("Daves weekly planner")
  end 

  it "displays an error when todo list has no title"  do 
    expect(TodoList.count).to eq(0)
    create_todo_list title: "hi"
    
    expect(TodoList.count).to eq(0)
    expect(page).to have_content(" Title is too short (minimum is 3 characters)
        ")
    visit "/todo_lists"
    expect(page).not_to have_content("On Monday the workouts begin")
  end 
  it "displays an error with bad descriptions" do 
    create_todo_list description: "big"

    expect(page).to have_content("Description is too short")
    expect(TodoList.count).to eq(0)
    visit "/todo_lists"
    expect(page).not_to have_content("apple")
  end 
end
