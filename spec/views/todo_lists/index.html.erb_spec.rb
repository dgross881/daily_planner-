require 'spec_helper'

describe "todo_lists/index" do
  before(:each) do
    assign(:todo_lists, [
      stub_model(TodoList,
        :title => "Title",
      ),
      stub_model(TodoList,
        :title => "Title",
      )
    ])
  end
end
