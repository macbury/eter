json.extract! user, :id, :full_name, :email, :initials
json.pending_invitation   user.pending_invitation?
