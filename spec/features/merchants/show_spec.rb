require 'rails_helper'

RSpec.describe 'Merchant Show Dashboard Page', type: :feature do
  let!(:merchant1) {Merchant.create!(name:'Steve')}
  let!(:merchant2) {Merchant.create!(name:'Fred')}
  let!(:bulk1) {BulkDiscount.create!(percentage_discount: 20, quantity_threshold: 10, merchant_id: merchant1.id)}
  let!(:bulk2) {BulkDiscount.create!(percentage_discount: 30, quantity_threshold: 15, merchant_id: merchant1.id)}
  let!(:bulk3) {BulkDiscount.create!(percentage_discount: 15, quantity_threshold: 5, merchant_id: merchant2.id)}

  before(:each) do
    test_data
  end

  describe "As a merchant visiting '/merchants/:id/dashboard'" do
    it 'I see the name of my merchant' do
      visit merchant_dashboard_path(merchant1)
      
      expect(page).to have_content('Steve')
    end
    
    it 'has a link to merchant items index' do
      visit merchant_dashboard_path(merchant1)
      
      expect(page).to have_link('My Items')
      click_link("My Items")
      expect(current_path).to eq(merchant_items_path(merchant1))
    end
    
    it 'has a link to merchant invoice index' do
      visit merchant_dashboard_path(merchant1)
      
      expect(page).to have_link('My Invoices')
      click_link("My Invoices")
      expect(current_path).to eq(merchant_invoices_path(merchant1))
    end

    describe 'shows the names of the top 5 customers' do
      it 'who have conducted the largest number of successful transactions with my merchant' do
        visit merchant_dashboard_path(@merchant)
        
        expect(page).to have_content('Favorite Customers')
        expect(page).to have_content("#{@customer6.first_name} #{@customer6.last_name} - 4 purchases")
        expect(page).to have_content("#{@customer2.first_name} #{@customer2.last_name} - 3 purchases")
        expect(page).to have_content("#{@customer3.first_name} #{@customer3.last_name} - 2 purchases")
        expect(page).to have_content("#{@customer4.first_name} #{@customer4.last_name} - 2 purchases")
        expect(page).to have_content("#{@customer5.first_name} #{@customer5.last_name} - 2 purchases")
        expect(page).to_not have_content("#{@customer1.first_name} #{@customer1.last_name}")
        
        expect(@customer6.first_name).to appear_before(@customer2.first_name)
        expect(@customer2.first_name).to appear_before(@customer3.first_name)
        expect(@customer3.first_name).to appear_before(@customer4.first_name)
        expect(@customer4.first_name).to appear_before(@customer5.first_name)
        expect(@customer5.first_name).to_not appear_before(@customer2.first_name)
      end
    end
    
    describe "I see a section for 'Items Ready to Ship'" do
      describe 'shows a list of the names of all of my items that have been ordered and have not yet been shipped,' do
        it "Next to each Item I see the id of the invoice that ordered my item And each invoice id is a link to my merchant's invoice show page" do
          visit merchant_dashboard_path(@merchant)
          
          expect(page).to have_content("Items Ready To Ship")
          expect(page).to have_content("#{@item1.name} - Invoice ##{@invoice2.id}")
          expect(page).to have_content("#{@item2.name} - Invoice ##{@invoice3.id}")
          expect(page).to_not have_content("#{@item3.name} - Invoice ##{@invoice6.id}")
          expect(page).to_not have_content("#{@item1.name} - Invoice ##{@invoice1.id}")
          expect(page).to have_link("#{@invoice2.id}")
          expect(page).to have_link("#{@invoice3.id}")
        end

        it 'has a link to the merchant invoice show page' do
          visit merchant_dashboard_path(@merchant)
          click_link("#{@invoice2.id}")
          
          expect(current_path).to eq(merchant_invoice_path(@merchant.id, @invoice2.id))
        end
        
        it 'I can see the date formatted like "Monday, July 18, 2019"' do
          @invoice2.update(created_at: '23 Oct 2021')
          @invoice3.update(created_at: '22 Oct 2021')
          
          visit merchant_dashboard_path(@merchant)

          expect(page).to have_content(@invoice2.created_at.strftime("%A %B %d %Y"))
          expect(@invoice2.created_at.strftime("%A %B %d %Y")).to appear_before(@invoice3.created_at.strftime("%A %B %d %Y"))
        end
      end

      describe 'User Story 1 When I visit my merchant dashboard' do
        it "I see a link to view all my discounts" do
        visit merchant_dashboard_path(@merchant)
       
    
        expect(page).to have_link("View My Discounts")
        click_link("View My Discounts")
        expect(current_path).to eq(merchant_bulk_discounts_path(@merchant))
        end

        it "I am taken to my bulk discounts index page were I see all of my bulk discounts including their percentage discount and quantity thresholds" do
          visit merchant_bulk_discounts_path(merchant1)
          save_and_open_page

          within"h1" do
            expect(page).to have_content("Bulk Discounts Index Page")
          end

          within"h3" do
            expect(page).to have_content("#{merchant1.name} Discounts")
          end

          within ".bulk_discount" do
            expect(page).to have_content("Discount: 20")
            expect(page).to have_content("Discount: 30")
            expect(page).to have_content("Minimum Quantity: 10")
          end
        end

        it 'each bulk discount listed has a link to its show page' do
         
        visit merchant_bulk_discounts_path(merchant1)
        save_and_open_page

        expect(page).to have_link(bulk1.id)
        click_link(bulk1.id)
        expect(current_path).to eq(merchant_bulk_discount_path(merchant1, bulk1))
        end
      end
    end
  end
end
