# frozen_string_literal: true
class BenefitFormsController < ApplicationController

  def index
    @benefits = Benefits.new
  end

  def download
   begin
     path = params[:name]
     allowed_types = {
       "AllowedType1" => AllowedType1,
       "AllowedType2" => AllowedType2
     } # Replace with actual allowed types
     if allowed_types.key?(params[:type])
       file_class = allowed_types[params[:type]]
       file = file_class.new(path)
       send_file file, disposition: "attachment"
     else
       flash[:error] = "Invalid file type"
       redirect_to user_benefit_forms_path(user_id: current_user.id) and return
     end
   rescue
     redirect_to user_benefit_forms_path(user_id: current_user.id)
   end
  end

  def upload
    file = params[:benefits][:upload]
    if file
      flash[:success] = "File Successfully Uploaded!"
      Benefits.save(file, params[:benefits][:backup])
    else
      flash[:error] = "Something went wrong"
    end
    redirect_to user_benefit_forms_path(user_id: current_user.id)
  end

end
