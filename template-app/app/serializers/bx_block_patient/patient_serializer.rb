module BxBlockPatient
    class PatientSerializer < BuilderBase::BaseSerializer
  
      attributes *[
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
          :pincode
      ]  
    end
  end
  