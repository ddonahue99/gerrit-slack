class Ability
  include CanCan::Ability
  def initialize(user)
    can :access, :rails_admin
    can :dashboard
    can :read, :all
    if user.superadmin?
      can :manage, :all
    else user.admin?
      can :manage, Channel
      cannot :destroy, Channel
      can :manage, Alias
      cannot :destroy, Alias
    end
  end
end