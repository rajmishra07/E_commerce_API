ActiveAdmin.register OrderItem do
  permit_params :order_id, :product_id, :quantity

  form do |f|
    f.inputs 'Order Item Details' do
      f.input :order, as: :select, collection: Order.all.map { |o| [o.id, o.id] }
      f.input :product, as: :select, collection: Product.all.map { |p| [p.name, p.id] }
      f.input :quantity
    end
    f.actions
  end
end