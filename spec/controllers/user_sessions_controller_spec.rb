require 'spec_helper'

describe UserSessionsController do

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      response.should be_success
    end

    it "renders the new templat" do
      get 'new' 
      expect(response).to render_template('new')
    end
  end
    
  describe "POST 'create'" do
   context "with correct credentials" do 
     let!(:user)  {  User.create(first_name: "David", last_name: "Gross", email: "dgross881@gmail.com", password: "foobar", password_confirmation: "foobar") } 

     it "redirects to the todo list path" do
        post :create, email: "dgross881@gmail.com", password: "foobar"
        expect(response).to be_redirect
        expect(response).to redirect_to(todo_lists_path)
     end
     
     it "sets the rememeber_me_token_cookie" do
       expect(cookies).to_not have_key('remember_me_token') 
        post :create, email: "dgross881@gmail.com", password: "foobar", remember_me: "1" 
       expect(cookies).to have_key('remember_me_token') 
    end
    
     it "finds the user" do
        expect(User).to receive(:find_by).with({email: "dgross881@gmail.com"}).and_return(user) 
        post :create, email: "dgross881@gmail.com", password: "foobar"
     end
    
     it "authenticates the user" do
        User.stub(:find_by).and_return(user)
        expect(user).to receive(:authenticate) 
        post :create, email: "dgross881@gmail.com", password: "foobar"
     end 

     it "sets the user_id in the session" do
       post :create, email: "dgross881@gmail.com", password: "foobar"
       expect(session[:user_id]).to eq(user.id)
     end

     it "sets a flash success message" do
       post :create, email: "dgross881@gmail.com", password: "foobar"
       expect(flash[:success]).to eq("Thanks for logging in") 
     end
     
   end
  
  shared_examples_for "denied login" do 
     it "renders the new template" do
       post :create, email: email, password: password
       expect(response).to render_template('new')
     end
     
     it "sets falsh error message" do
       post :create
       expect(flash[:error]).to eq("Error please try again") 
     end
   end 
   
   context "with blank credentials" do  
     let(:email) {""}
     let(:password) {""}
     it_behaves_like "denied login"
    end
   
   context "with incorrect password" do  
      let!(:user)  {  User.create(first_name: "David", last_name: "Gross", email: "dgross881@gmail.com", password: "foobar", password_confirmation: "foobar") }  
      let!(:email) {user.email} 
      let!(:password) {"wrong"}
      it_behaves_like "denied login" 
    end 
   
   context "with inccorect email" do
      let!(:user)  {  User.create(first_name: "David", last_name: "Gross", email: "dgross881@gmail.com", password: "foobar", password_confirmation: "foobar") }  
     let(:email) {"daniel@gamail.com"}
     let(:password) { user.password }
     it_behaves_like "denied login"  
   end
   
     it "renders the new template" do
       post :create
       expect(response).to render_template('new')
     end
     
     it "sets flash error message" do
       post :create
       expect(flash[:error]).to eq("Error please try again") 
     end
    end
  end

