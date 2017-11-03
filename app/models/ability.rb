class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, Comment
      can :manage, User
      can :manage, Order
      can :manage, Product
    else
      can :show, User, id: user.id
      can :update, User, id: user.id
      cannot :admin, User
      can :manage, Order, user_id: user.id
      can :create, Comment, user_id: user.id
    end
  end
end
