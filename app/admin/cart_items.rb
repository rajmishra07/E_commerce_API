ActiveAdmin.register CartItem do
  permit_params :product_id, :quantity, :cart_id

  index do
    selectable_column
    id_column
    column :product
    column :quantity
    column :cart
    actions
  end

  form do |f|
    f.inputs do
      f.input :product
      f.input :quantity
      f.input :cart, collection: Cart.all.map { |c| [c.display_name, c.id] }  # Custom display
    end
    f.actions
  end
end
