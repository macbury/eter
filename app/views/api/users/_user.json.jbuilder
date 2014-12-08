json.extract! user, :id, :full_name, :email, :initials
json.avatar nil
json.pending_invitation   user.pending_invitation?
