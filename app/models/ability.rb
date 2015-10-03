class Ability
  include CanCan::Ability
  def initialize(user)
    user ||= User.new # guest user (not logged in)
    can :access, :rails_admin   # grant access to rails_admin
    can :dashboard              # grant access to the dashboard
    if user.admin?
      can :manage, Channel
      cannot :destroy, Channel
      can :manage, Alias
      cannot :destroy, Alias
    elsif user.superadmin?
      can :manage, :all
    else
      can :read, :all
    end
  end
end