class UserMailer < ActionMailer::Base
  
  def send_error
    recipients    "angmeng@gmail.com"
    from          "Notifications <notifications@al-lighting.com>"
    subject       "Error detail"
    sent_on       Time.now
    #body          {:user => user, :url => "http://example.com/login"}
  end
end
