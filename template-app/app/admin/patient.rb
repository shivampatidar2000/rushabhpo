ActiveAdmin.register AccountBlock::Patient, as: "Patient" do
    permit_params :first_name, :last_name, :email, :phone_no, :alternative_no,:account_id, :address, :city, :country, :gender, :date_of_birth, :weight, :landmark, :pincode, images: []
  
    index do
      selectable_column
      id_column
      column :first_name
      column :last_name
      column :email
      column :phone_no
      column :alternative_no
      column :dooctor do |object|
        object.first_name + object.last_name
      end
      column :address
      column :city
      column :country
      column :gender
      column :date_of_birth
      column :weight
      column :landmark
      column :pincode
      column :images
      column :created_at
      actions
    end

    show do
      attributes_table do
        row :first_name
        row :last_name
        row :email
        row :phone_no
        row :alternative_no
        row :doctor do |object|
          object.first_name + object.last_name
        end
        row :address
        row :city
        row :country
        row :gender
        row :date_of_birth
        row :weight
        row :landmark
        row :pincode
        row "Images" do
          ul do
           patient.images.each do |img|
             li do 
               image_tag(img, size: '100x100')
             end
           end
          end
       end
      
        row :created_at
        row :updated_at
      end
    end
  
    filter :first_name
    filter :last_name
    filter :email
    filter :phone_no
    filter :alternative_no
    filter :account_id
    filter :address
    filter :city
    filter :country
    filter :gender
    filter :date_of_birth
    filter :weight
    filter :landmark
    filter :pincode
    filter :images
    filter :created_at
  
    form do |f|
      f.inputs do
        f.input :first_name
        f.input :last_name
        f.input :email
        f.input :phone_no, label: 'Phone no.'
        f.input :alternative_no, label: 'Alternative Ph.no'
        f.input :account, label: 'Doctor', as: :select, collection: AccountBlock::Account.all.map{ |a| [a.first_name, a.id] }
        f.input :address, label: 'Local Address'
        f.input :city
        f.input :country,as: :select, collection: CS.countries.map{|code, name|  name }
        f.input :gender, as: :select, collection: %w(Male Female)
        f.input :date_of_birth, as: :datepicker
        f.input :weight
        f.input :landmark
        f.input :pincode
        f.input :images, :as => :file, input_html: {multiple: true}
      end
      f.actions
    end
  
  end
  