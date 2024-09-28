ActiveAdmin.register Product do
  permit_params :name, :price, :description, :user_id

  index do
    selectable_column
    id_column
    column :name
    column :price
    column :description
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :price
      f.input :description
      f.input :user_id, as: :select, collection: User.all.map { |u| [u.email, u.id] }  # Associate product with a user
    end
    f.actions
  end
end