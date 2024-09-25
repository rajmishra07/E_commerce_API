ActiveAdmin.register Product do
  permit_params :name, :description, :price, :stock, :user_id # Add other attributes as necessary

 
  index do
    selectable_column
    id_column
    column :name
    column :description
    column :price
    column :stock
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :description
      f.input :price
    end
    f.actions
  end
end
