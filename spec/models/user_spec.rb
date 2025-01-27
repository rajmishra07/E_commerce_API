require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

 
  it { should have_many(:products).dependent(:destroy) }
  it { should have_one(:cart).dependent(:destroy) }


  it 'should have many cart_items through cart' do
    cart = create(:cart, user: user)
    product = create(:product, user: user)
    cart_item = create(:cart_item, cart: cart, product: product, quantity: 1)

    expect(user.cart.cart_items).to include(cart_item)
  end

  # Validation tests
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }

  # Role tests
  describe 'roles' do
    it 'is valid with a user role' do
      user = create(:user, role: 'user')
      expect(user.role).to eq('user')
    end

    it 'is valid with a vendor role' do
      user = create(:user, :vendor)
      expect(user.role).to eq('vendor')
    end

    it 'is valid with an admin role' do
      user = create(:user, :admin)
      expect(user.role).to eq('admin')
    end

    it 'defaults to user role if no role is specified' do
      user = create(:user, role: nil)
      expect(user.role).to eq('user')
    end
  end
end
