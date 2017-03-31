class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    case user.role
      when "admin"
        can :manage, :all
      when "user"        
        can :read, [Category, Comment, Order, OrderDetail, Product, Rating,
          SuggestProduct, User]
        can :create, [Comment, Order, OrderDetail, Rating, SuggestProduct]
        can :update, [Comment, Rating]
        can :delete, [Comment]
      else
        can :read, [Category, Comment, Order, OrderDetail, Product, Rating,
          SuggestProduct, User]
    end
  end
end
