class PagesController < ApplicationController
  def home
   redirect_to todo_lists_path and return if logged_in?
   render layout: 'home'
  end
end
