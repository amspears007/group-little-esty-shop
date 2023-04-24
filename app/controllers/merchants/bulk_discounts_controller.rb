class Merchants::BulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @merchant_discounts = @merchant.bulk_discounts
  end
  
  def show

  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.new(merchant_id: @merchant.id)
  end

  def create
    merchant = Merchant.find(params[:merchant_id])
    discount = BulkDiscount.create!(bulk_discount_params)
    redirect_to merchant_bulk_discounts_path(merchant)
  end

  def bulk_discount_params
    params.permit(:percentage_discount, :quantity_threshold, :merchant_id)
  end
end