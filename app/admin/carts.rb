ActiveAdmin.register Cart do
  permit_params :user_id

  index do
    selectable_column
    id_column
    column :user
    actions do |cart|
      item 'View', admin_cart_path(cart)
      item 'Edit', edit_admin_cart_path(cart)
      item 'Delete', admin_cart_path(cart), method: :delete, data: { confirm: 'Are you sure?' }
    end
  end

  form do |f|
    f.inputs do
      f.input :user, as: :select, collection: User.all.map { |u| [u.email, u.id] }, include_blank: false  # Ensure the user is selectable
    end
    f.actions
  end

end