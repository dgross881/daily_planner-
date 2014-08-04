require 'spec_helper'

feature "Creating todo lists" do
  let(:user) { create(:user) }

  def create_todo_list(options={})
    options[:title] ||= "My todo list"

    visit "/todo_lists"
    click_link "Todo List"
    expect(page).to have_content("New Todo List")

    fill_in "Title", with: options[:title]
    click_button "Create Todo list"
  end

  before do
    sign_in user, password: "treehouse1"
  end

  scenario "redirects to the todo list index page on success" do
    create_todo_list
    expect(page).to have_content("My todo list")
  end

  scenario "displays an error when the todo list has no title" do
    expect(TodoList.count).to eq(0)

    create_todo_list title: ""

    expect(page).to have_content("error")
    expect(TodoList.count).to eq(0)

    visit "/todo_lists"
    expect(page).to_not have_content("This is what I'm doing today.")
  end

  scenario "displays an error when the todo list has a title less than 3 characters" do
    expect(TodoList.count).to eq(0)

    create_todo_list title: "Hi"

    expect(page).to have_content("error")
    expect(TodoList.count).to eq(0)

    visit "/todo_lists"
    expect(page).to_not have_content("This is what I'm doing today.")
  end

end
