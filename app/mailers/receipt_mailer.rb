class ReceiptMailer < ActionMailer::Base
  default from: "pouyajoon@gmail.com"

  def welcome()
    @url  = 'http://example.com/login'
    mail(to: 'pouyajoon@gmail.com', subject: 'Welcome to My Awesome Site')
  end
end
