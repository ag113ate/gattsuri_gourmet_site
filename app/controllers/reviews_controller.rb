class ReviewsController < ApplicationController
  def new
  end

  def create
  end

  def show
    @store = Store.find_by(store_id: params[:id])
  end

  def edit
  end

  def delete
  end
end
