class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.admin?
      can :manage, :all
    else
      can :show, User, id: user.id
      can :update, User, id: user.id
      can [:show, :index], Order, user_id: user.id
      # can :destroy, Product, Product do |product|
      #   product.orders.active.take.user.id = user.id
      # end
      # can :remove_from_cart, Product
      # can :add_to_cart, Product
      # can :add_to_cart, Product, Product do |product|
      #   product.orders.where('order_id = ?', user.active_order.id).user.id = user.id
      # end

      can :destroy, OrderProduct, order_id: user.active_order.id
      can :create, OrderProduct, order_id: user.active_order.id
      can :create, Comment, user_id: user.id
      can :show, Comment
    end
  end
end
