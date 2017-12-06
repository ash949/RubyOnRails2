NOT_AUTHORIZED_MESSAGE = "You are not authorized to access this page."
NOT_AUTHENTICATED_MESSAGE = "You need to sign in or sign up before continuing."
NO_ID_PROVIDED_MESSAGE = 'No valid ID provided to show the object'

def skip_confirmation_and_save_users(*users)
  users.each do |user|
    user.skip_confirmation!
    user.save
  end
end