class PetsController < ApplicationController
  def create
    cry = @Cry.find!(params[:cry_id])
    current_user.pets.new(cry.id).save
  end

  def destroy
    cry = @Cry.find!(params[:cry_id])
    current_user.pets.find_by!(cry_id: cry.id).destroy
  end
end
