class Ability
  include CanCan::Ability

  def initialize(user)
    if user.present?
      if user.admin?
        can :manage, Product 
      elsif user.user?
        can :read, Product 
        can :create, CartItem 
        can :manage, CartItem, cart: { user_id: user.id }  
      elsif user.vendor?
        can :create, Product  
        can :manage, Product, user_id: user.id
        can :read, Product, user_id: user.id 
      end
    else
      can :read, Product  
    end
  end
end