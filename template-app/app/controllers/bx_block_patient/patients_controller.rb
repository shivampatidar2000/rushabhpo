module BxBlockPatient
    class PatientsController < ApplicationController
      before_action :find_patient, only: [:show, :update, :destroy]

        
    def index
      patients = AccountBlock::Patient.all
      if patients.present?
       render json: {patients: PatientSerializer.new(patients).serializable_hash}, status: :ok
      else
        render json: {data: []}, status: :ok
      end
    end

    def show
        render json: PatientSerializer.new(@patient).serializable_hash,status: :ok
    end

    def create
        #  params[:data][:attributes][:account_id] = current_user.id
        @patient = AccountBlock::Patient.new(patient_params)
        if @patient.save
            
            render json: PatientSerializer.new(@patient).serializable_hash,status: :ok
        else
            render json: @patient.errors.messages.to_json, status: :unprocessable_entity
        end
    end
    def update
        if @patient.update(patient_params)
            render json: {message: "Patient Successfully Updated"}, status: :ok
        else
            render json: {message: "Patient not Update"}, status: :unprocessable_entity
        end 
    end
    
    
    def destroy
        if @patient.destroy
            render json: {message: "Patient Successfully Deleted"}, status: :ok
        else
            render json: {message: "Patient not Delete"}, status: :unprocessable_entity
        end
    end
    
    def user_patients
        patients = current_user.patients.all
        if patients.present?
            render json: {patients: PatientSerializer.new(patients).serializable_hash}, status: :ok
           else
             render json: {data: []}, status: :ok
           end
          end

    private

    def find_patient
        @patient = AccountBlock::Patient.find(params[:id]) rescue nil
        return render json: {message: "Patient not found!"}, status: :unprocessable_entity if !@patient
    end

    def patient_params
        params.require(:data)[:attributes].permit(
            :id, :first_name, :last_name, :email, :phone_no, :alternative_no, :account_id, :address,:city, :country, :gender, :date_of_birth, :weight, :landmark, :pincode, :image)
    end 
  end 
end