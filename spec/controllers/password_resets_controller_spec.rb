require 'spec_helper'

describe PasswordResetsController do
  describe "Get new" do
    it "renders the new templates" do
      get :new
      expect(response).to  render_template('new')
    end
  end

  describe "POST create" do
    context "with a valid user and email" do
      let(:user) {create(:user) } 

    it "finds the user" do
      expect(User).to receive(:find_by).with(email: user.email).and_return(user)
      post :create, email: user.email 
    end  

    it "generates a new password reset token" do
      expect{ post :create, email: user.email; user.reload }.to change{ user.password_reset_token}
    end

    it "sends a password reset email to the user" do
      expect{ post :create, email: user.email}.to change(ActionMailer::Base.deliveries, :size)
    end

    it "sets the flash success message for email being sen" do
     post :create, email: user.email
     expect(flash[:success]).to match(/check your email/) 
    end
   end

   context "with no users found" do
     it "renders the new page" do
       post :create, email: 'none@found.com'
       expect(response).to render_template('new')
     end 

     it "sets the flash message" do
       post :create, email: 'none@found.com'
       expect(flash[:notice]).to match(/not found/)
     end
   end
  end

  describe "GET edit" do
    context "with a valid password reset token user can edit password" do
      let(:user) {create(:user) }
      before { user.generate_password_reset_token! }

      it "render the edit template page" do
        get :edit, id: user.password_reset_token 
        expect(response).to render_template('edit') 
      end   

      it "assigns a @user" do
        get :edit, id: user.password_reset_token
        expect(assigns(:user)).to eq(user) 
      end
     end

     context "with no password_reset_token found"
      it "renders the 404 page" do
        get :edit, id:'boobs'
        expect(response.status).to eq(404)
        expect(response).to render_template(file: "#{Rails.root}/public/404.html")
      end
    end
  
  describe "Patch update" do
     context "with no token found" do
       it "renders edit page" do
         patch :update, id: 'notfound', user: { password: 'newpassword1', password_confirmation: 'newpassword1' }
         expect(response).to render_template('edit')
       end
       
       it "sets the flash message" do
         patch :update, id: 'notfound', user: {password: 'newpassword1', password_confirmation: 'newpassword1'}
         expect(flash[:notice]).to match(/not be found/) 
       end
     end
     
     context "message" do
       let(:user) {create(:user) }
       before { user.generate_password_reset_token! }

       it "updates the users password" do
         digest = user.password_digest
           patch :update, id: user.password_reset_token, user: { password: 'newpassword', password_confirmation: 'newpassword' }
           user.reload
           expect(user.password_digest).to_not eq(digest)
       end

       it "clears the password_reset_token" do
           patch :update, id: user.password_reset_token, user: { password: 'newpassword', password_confirmation: 'newpassword' }
         user.reload 
         expect(user.password_reset_token).to be_blank
       end

       it "set the session[:user_id] to the user's idse" do
           patch :update, id: user.password_reset_token, user: { password: 'newpassword', password_confirmation: 'newpassword' }
           expect(session[:user_id]).to eq(user.id) 
       end
       it "sets the flash[:success] message to apear" do
           patch :update, id: user.password_reset_token, user: { password: 'newpassword', password_confirmation: 'newpassword' }
           expect(flash[:success]).to match(/password has been updated/) 
       end
       it "redirects to the todo list path" do
           patch :update, id: user.password_reset_token, user: { password: 'newpassword', password_confirmation: 'newpassword' }
           expect(response).to redirect_to(todo_list_path) 
       end

     end
    end 
  end
