class ReviewsController < ApplicationController
  before_action :shelter, only: [:new, :create]
  before_action :review, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(name: params[:name])
    if @user
      save_review(@user)
    else
      flash.now[:errors] = "User Must Exist"
      render :new
    end
  end

  def edit
  end

  def update
    @user = User.find_by(name: params[:user])
    if @user
      update_review(@user)
    else
      flash.now[:errors] = "User Must Exist"
      render :edit
    end
  end

  def destroy
    review.destroy
    redirect_to "/shelters/#{params[:shelter_id]}"
  end

  private
  def review_params
    default_image = "https://media3.giphy.com/media/o0vwzuFwCGAFO/giphy.gif?cid=790b761143794a0c3a7b311e04b4bbf2966d12685520db43&rid=giphy.gif"
    if params[:image] != ""
      params.permit(:title, :rating, :content, :image, :shelter_id, :user_id)
    else
      params.permit(:title, :rating, :content, :shelter_id, :user_id).merge({image: default_image})
    end
  end

  def shelter
    @shelter ||= Shelter.find(params[:shelter_id])
  end

  def review
    @review ||= Review.find(params[:id])
  end

  def save_review(user)
    @review = user.reviews.new(review_params)
    if @review.save
      redirect_to "/shelters/#{params[:shelter_id]}"
    else
      flash.now[:errors] = "#{@review.errors.full_messages.to_sentence}"
      render :new
    end
  end

  def update_review(user)
    @review = Review.find(params[:id])
    @review.update(review_params)
    if @review.save
      redirect_to("/shelters/#{review_params[:shelter_id]}")
    else
      flash.now[:errors] = "#{@review.errors.full_messages.to_sentence}"
      render :edit
    end
  end
end
