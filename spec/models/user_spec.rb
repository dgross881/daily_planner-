require 'spec_helper'

describe User do
  let(:valid_attributes){
    { 
     first_name: "David",
     last_name: "Gross",
     email: "dgross881@gamil.com",
     password: "foobar",
     password_confirmation: "foobar"
    } 
  }
  
  context "relationships" do 
    it {should have_many(:todo_lists) } 
  end 

  context "validations" do
   let(:user) { User.new(valid_attributes) }  
   
   before do 
     User.create(valid_attributes)
   end 
   
   it "requires an email" do
       expect(user).to validate_presence_of(:email)      
     end 
    
    it "requires a unique email" do
       expect(user).to validate_uniqueness_of(:email)   
    end
    
    it "requires a unique emaili (case insensitive)" do
       user.email = "DGROSS881@GMAIL.com"
       expect(user).to validate_uniqueness_of(:email)   
    end

    it "requires the email address to look like and email address" do
       user.email = "Jason"
       expect(user).to_not be_valid 
    end 
   end

   context "#downcase_email" do
     it "makes the email attribute lower case" do
       user =  User.new(valid_attributes.merge(email: "DGROSS881@GMAIL.com"))
       user.downcase_email 
       expect(user.email).to eq("dgross881@gmail.com")
     end
    
     it "downcases an email before saving" do
       user = User.new(valid_attributes)
       user.email = "DGROSS881@GMAIL.COM"
       expect(user.save).to be_true
       expect(user.email).to eq("dgross881@gmail.com")
     end
   end

   describe "#generate_password_reset_token!" do
    let(:user) { create(:user) } 
    it "changes the password_reset_token attribute" do
      expect{user.generate_password_reset_token!}.to change{user.password_reset_token} 
    end

    it "calls SecureRandom.urlsafe_base64 to generate the password_reset_token" do
    expect(SecureRandom).to receive(:urlsafe_base64)
    user.generate_password_reset_token! 
    end
   end 

   describe "#create_default_lists" do
      let(:user) { create(:user) }
    it "creates a todo list" do
       expect{ user.create_default_lists}.to change{user.todo_lists.size }.by(1) 
    end
    
    it "It does not create the same todo list twice" do
      expect{ user.create_default_lists}.to change{user.todo_lists.size }.by(1) 
      expect{ user.create_default_lists}.to change{user.todo_lists.size }.by(0) 
    end

    it "creates todo items" do
      expect{ user.create_default_lists}.to change{TodoItem.count }.by(7) 
      
    end

    it "It does not create the same todo list twice" do
       expect{ user.create_default_lists}.to change{TodoItem.count }.by(7) 
       expect{ user.create_default_lists}.to change{TodoItem.count }.by(0) 
    end
   end
  end
  
