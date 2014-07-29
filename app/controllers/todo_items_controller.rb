class TodoItemsController < ApplicationController
  before_action :find_todo_list
  
  def index
  end

  def new 
    @todo_item = @todo_list.todo_items.new
  end

  def create
     @todo_item = @todo_list.todo_items.new(todo_items_param)
     if @todo_item.save 
       flash[:success] = "Added todo list item"
       redirect_to todo_list_todo_items_path
     else
       flash[:error] = "List item did not save"
       render action: :new 
    end 
   end 

   def edit 
    @todo_item = @todo_list.todo_items.find(params[:id]) 
   end 

   def update
     @todo_item = @todo_list.todo_items.find(params[:id])
     if @todo_item.update_attributes(todo_items_param) 
       flash[:success] = "Saved todo list item"
       redirect_to todo_list_todo_items_path
     else
       flash[:error] = "That todo item did not save"
       render action: :edit 
    end 
   end 
 
   def url_options
    {todo_list_id: params[:todo_list_id] }.merge(super) 
   end 
  end
  
  private 
  def find_todo_list
    @todo_list = TodoList.find(params[:todo_list_id]) 
  end 
  
  def todo_items_param
    params[:todo_item].permit(:content)
  end 
