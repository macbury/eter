class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.has_role?(:admin)
      can :manage, :all
    else
      can :index, Project
      can :read, Project do |project|
        user.has_role?([:master, :developer], project)
      end
      
      can :create, Project

      can :manage, Project do |project|
        user.has_role?(:master, project)
      end
    end
  end
end
