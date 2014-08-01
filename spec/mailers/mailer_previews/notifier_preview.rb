class NotifierPreview < ActionMailer::Preview
 def password_reset 
   user = User.create(first_name: "David", last_name: "Gross", email: "thisguy@gmail.com", password: "thisguy123", password_confirmation: "thisguy123") 
   user.generate_password_reset_token!
   mailer = Notifier.password_reset(user) 
   user.destroy
   mailer
 end
end 
