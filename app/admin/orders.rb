ActiveAdmin.register Order do
  permit_params :user_id, :status, 
                order_items_attributes: [:id, :product_id, :quantity, :_destroy]

  form do |f|
    f.inputs 'Order Details' do
      f.input :user, as: :select, collection: User.all.map { |u| [u.email, u.id] }, prompt: "Select a User"
      f.input :status, as: :select, collection: Order::STATUSES
    end

    f.has_many :order_items, allow_destroy: true, new_record: true do |item_f|
      item_f.input :product
      item_f.input :quantity
    end

    f.actions
  end

  index do
    selectable_column
    id_column
    column :user
    column :status
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :user
      row :status
      row :created_at
    end

    panel 'Order Items' do
      table_for order.order_items do
        column :product
        column :quantity
      end
    end
  end
end