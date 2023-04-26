require 'rails_helper'

RSpec.describe 'Merchant Bulk Discounts Index', type: :feature do
  let!(:merchant1) {Merchant.create!(name:'Steve')}
  let!(:merchant2) {Merchant.create!(name:'Fred')}
  let!(:bulk1) {BulkDiscount.create!(percentage_discount: 20, quantity_threshold: 10, merchant_id: merchant1.id)}
  let!(:bulk2) {BulkDiscount.create!(percentage_discount: 30, quantity_threshold: 15, merchant_id: merchant1.id)}
  let!(:bulk3) {BulkDiscount.create!(percentage_discount: 15, quantity_threshold: 5, merchant_id: merchant2.id)}

  before(:each) do
    test_data
  end

  describe "merchant_bulk_discounts_path(merchant1)" do
    it "I see a link to create a new discount, when I click this link I am taken to a new page where I see a form to add a new bulk discount I fill in the form with valid data" do
      visit merchant_bulk_discounts_path(merchant1)
      click_link 'New Discount'
      
      expect(current_path).to eq(new_merchant_bulk_discount_path(merchant1))
      
      expect(page).to have_field(:percentage_discount)
      fill_in 'Percentage Discount', with: 10
      fill_in 'Quantity Threshold', with: 5
      click_button "Add Discount"
      
      expect(current_path).to eq(merchant_bulk_discounts_path(merchant1))
      expect(page).to have_content('Discount: 10 %')
      expect(page).to have_content('Minimum Quantity: 5')
      end
    end

    describe 'US3 ' do 
      it 'next to each bulk discount I see a link to deleted' do
      visit merchant_bulk_discounts_path(merchant1)
     
        expect(page).to have_link("Delete #{bulk1.id}")
      end

      it 'when I click this link I am redirected back to the bulk discounts index page and I no longer see the discount listed' do
        visit merchant_bulk_discounts_path(merchant1)

        click_link("Delete #{bulk1.id}")
        expect(current_path).to eq(merchant_bulk_discounts_path(merchant1))
        expect(page).to_not have_content(bulk1.id)
      end
    end
  end
