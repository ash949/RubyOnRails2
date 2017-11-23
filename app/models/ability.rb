# CANCANCAN-gem related model
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.admin?
      can :manage, :all
    else
      can %i[show update], User, id: user.id
      can %i[show index], Order, user_id: user.id
      can %i[destroy create], OrderProduct, order_id: user.active_order.id
      can :create, Comment, user_id: user.id
      can :show, Comment
    end
  end
end
