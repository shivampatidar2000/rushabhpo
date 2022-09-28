ActiveAdmin.register AccountBlock::Account, as: "Doctor" do
  permit_params :first_name, :email, :password, :password_confirmation, :image,
  patient_details_attributes: [
    :first_name, 
    :last_name, 
    :email, 
    :phone_no, 
    :alternative_no,
    :address, 
    :city, 
    :country, 
    :gender, 
    :date_of_birth, 
    :weight,
    :landmark,
    :pincode,
    :image,
    :_destroy
  ]

  show do
    attributes_table title:"Doctor" do
      row :first_name
      row :email
      row :password
      row :password_confirmation
      row :image do |a|
        image_tag url_for(a.image), size: '100x100' if a.image.present?
     end
      row :created_at
      row :updated_at
      # row :patients
   end
    panel "Patient Detail" do
      table_for doctor.patients do
        column :first_name
        column :last_name
        column :email
        column :phone_no
        column :alternative_no
        column :address
        column :city
        column :country
        column :gender
        column :date_of_birth
        column :weight
        column :landmark
        column :pincode
        column :image
      end
    end
  end
    index do
      selectable_column
      id_column
      column :first_name
      column :email
      column :password
      column :password_confirmation
      column :created_at
      actions
    end

    filter :name
    filter :created_at
  
    form do |f|
      f.inputs do
        f.input :first_name
        f.input :email
        f.input :password
        f.input :password_confirmation
        f.input :image, :as => :file
        # f.has_many :patient_details, allow_destroy: true do |pd|
        #   pd.input :first_name
        #   pd.input :last_name
        #   pd.input :email
        #   pd.input :phone_no
        #   pd.input :address
        #   pd.input :city
        #   pd.input :country
        #   pd.input
        # end
        f.actions
    end
  end

end
