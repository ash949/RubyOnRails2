class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    else
      can :show, User, id: user.id
      can :update, User, id: user.id
      can :manage, Order, user_id: user.id
      can :create, Comment, user_id: user.id
      can :show, Product
      can :index, Product
    end
  end
end
