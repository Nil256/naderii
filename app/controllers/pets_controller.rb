class PetsController < ApplicationController
  def create
    @cry = Cry.find_by(id: params[:cry_id])
    @found_cry = !(@cry.nil?)
    if !(user_signed_in?)
      flash.now[:danger] = "なでるにはログインする必要があります。"
    elsif !@found_cry
      flash.now[:danger] = "空をなでた！"
    elsif @cry.user_id == current_user.id
      @change_pet_button = true
      flash.now[:danger] = "確かに自分自身をなでたいときもあるよね...\nそういう時は自分のアイコンにマウスカーソルを合わせてみよう！"
    else
      pet = current_user.pets.new(cry_id: @cry.id)
      pet.save
    end
  end

  def destroy
    @cry = Cry.find_by(id: params[:cry_id])
    @found_cry = !(@cry.nil?)
    if user_signed_in? && @found_cry && @cry.user_id != current_user.id
      pet = current_user.pets.find_by!(cry_id: @cry.id)
      pet.destroy
    end
  end
end
