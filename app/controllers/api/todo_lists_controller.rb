class Api::TodoListsController < Api::ApiController 
 before_filter :find_todo_list 

 def index 
  Rails.logger.info "Current user: #{current_user.inspect}"
  render json: current_user.todo_lists
 end 

 def show
  list = current_user.todo_lists.find(params[:id])
  render json: list.as_json(include: [:todo_items])
 end

 def create 
   list = TodoList.new(list_params)
   if list.save
     render status: 200, json: {
       message: "Succesfully created To-do List.", 
       todo_list: list
     }.to_json
   else 
     render render: 422, json: {
       errors: list.errors
     }.to_json
   end
 end

 def update
  list = current_user.todo_lists.find(params[:id])
  if list.update(list_params)
     render status: 200, json: {
       message: "Succesfully updated To-do List.", 
       todo_list: list
     }.to_json
   else 
     render status: 422, json: {
       errors: list.errors
     }.to_json
   end
 end

  def destroy
    list = current_user.todo_lists.find(params[:id])
    list.destroy
    render status: 200, json: {
      message: "Succesfully deleted your todo list." 
    }.to_json
  end

 private

 def find_todo_list 
 end

 def list_params
   params.require(:todo_list).permit(:title, :description)
 end
end 
