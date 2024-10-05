RSpec.describe Api::V1::ProductsController, type: :controller do
  let(:vendor) { create(:user, role: 'vendor') }
  let(:another_vendor) { create(:user, role: 'vendor') }
  let!(:product) { create(:product, user: vendor) }
  let!(:other_product) { create(:product, user: another_vendor) }

  before do
    sign_in vendor
  end
  describe "GET #index" do
    context "when the user is an admin" do
      let(:admin) { create(:user, role: 'admin') }
      
      before do
        sign_in admin
      end

      it "returns all products" do
        get :index
        expect(assigns(:products)).to match_array([product, other_product])
        expect(response).to have_http_status(:ok)
      end
    end
  end


  describe "PUT #update" do
    context "when trying to update another vendor's product" do
      it "returns an error" do
        other_user = create(:user)
        other_product = create(:product, user: other_user)

        expect {
          put :update, params: { id: other_product.id, product: { name: 'Updated Name' } }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "DELETE #destroy" do
    context "when trying to delete another vendor's product" do
      it "raises an error" do
        other_user = create(:user)
        other_product = create(:product, user: other_user)

        expect {
          delete :destroy, params: { id: other_product.id }
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

end