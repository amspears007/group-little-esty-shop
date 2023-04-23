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
    it "I see a link to create a new discount, when I click this link I am taken to a new page where I see a form to add a new bulk discount" do
      visit merchant_bulk_discounts_path(merchant1)
    save_and_open_page
        click_link 'New Discount'

        expect(current_path).to eq(new_merchant_bulk_discount(merchant1))

      # fill_in 'Name', with: 'Megan'
      # click_on 'Create Artist'

      # expect(current_path).to eq("/artists")
      # expect(page).to have_content('Megan')

      end
    end
  end
#   2: Merchant Bulk Discount Create

# As a merchant
# When I visit my bulk discounts index
# Then I see a link to create a new discount
# When I click this link
# Then I am taken to a new page where I see a form to add a new bulk discount
# When I fill in the form with valid data
# Then I am redirected back to the bulk discount index
# And I see my new bulk discount listed