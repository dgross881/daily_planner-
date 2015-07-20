class Api::TodoItemsController < Api::ApiController
 before_filter :find_todo_list 
 before_filter :find_item 

 def create  
  item = @list.todo_items.new(item_params)
  if item.save?
  render status: 200, json: {
     message: "Succesfully created To-do List.", 
     todo_item: item
  }.to_json 
  else render status: 500, json: {
    errors: item.errors 
  }.to_json 
  end 
 end

 def update 
   if item.update(item_params)
     render status: 200, json {
       message: "Successfully update To-do item.", 
       todo_list: @todo_list,
       todo_item: item
     }.to_json
   else 
     render status: 422, json: {
      errors: item.errors  
     }.to_json
   end 
 end

 def destroy 
  item.destroy
  render status: 200, json: {
    message: "Succesfully deleted your todo item."   
  }
 end 


 private 
 def find_todo_list
   @list = current_user.todo_lists.find(params[:todo_list_id])
 end

 def find_item
  @item = @list.todo_items.new(item_params)
 end 

 def todo_item_params
   params[:todo_item].permit(:content)
 end
end 
