require 'rails_helper'

RSpec.describe Merchant, type: :model do
  it { should have_many(:items) }
  it { should have_many(:invoice_items).through(:items)}
  it { should have_many(:invoices).through(:items)}
  it { should have_many(:customers).through(:invoices)}
  it { should have_many(:bulk_discounts) }

  
  describe 'instance methods' do
    it '#invoice_items_data, to return a list of items for a specific merchant on a specific invoice' do
      merchant3_test_data

      expect(@merchant2.invoice_items_data(@invoice7.id)).to eq([@init1, @init8])
      expect(@merchant3.invoice_items_data(@invoice7.id)).to eq([@init10])
      expect(@merchant4.invoice_items_data(@invoice7.id)).to eq([])
    end

    it '#inv_total_rev can find the total revenue from an invoice for a specific merchant' do
      expect(@merchant2.inv_total_rev(@invoice7.id)).to eq(17500)
    end

    before(:each) do
      test_data
      merchant2_test_data
    end
    it '#top_5_customers' do
      expect(@merchant.top_5_customers).to match_array([@customer6, @customer2, @customer3, @customer4, @customer5])
    end
    
    it '#top_5_customers has the attribute of transaction_count' do
      expect(@merchant.top_5_customers.first.transaction_count).to eq(4)
      expect(@merchant.top_5_customers[1].transaction_count).to eq(3)
      expect(@merchant.top_5_customers[2].transaction_count).to eq(2)
      expect(@merchant.top_5_customers[3].transaction_count).to eq(2)
      expect(@merchant.top_5_customers[4].transaction_count).to eq(2)
    end

    it '#items_ready_to_ship' do
      @invoice2.update(created_at: '23 Oct 2021')
      @invoice3.update(created_at: '22 Oct 2021')

      expect(@merchant.items_ready_to_ship).to match_array([@item1, @item2])
      expect(@merchant.items_ready_to_ship.first.invoice_id).to eq(@invoice2.id)
      expect(@merchant.items_ready_to_ship[1].invoice_id).to eq(@invoice3.id)
    end

    it '#items_ready_to_ship has the attribute of invoice_creation' do
      @invoice2.update(created_at: '23 Oct 2021')
      @invoice3.update(created_at: '22 Oct 2021')

      expect(@merchant.items_ready_to_ship.first.invoice_creation).to eq(@invoice2.created_at)
      expect(@merchant.items_ready_to_ship[1].invoice_creation).to eq(@invoice3.created_at)
    end

    it '#disabled_items, returns a list of items with a disabled status for a merchant' do
      @item1.update(status: 1)
      @item3.update(status: 1)
      expect(@merchant.disabled_items).to match_array([@item2, @item4, @item5])
    end

    it '#enabled_items, returns a list of items with an enabled status for a merchant' do
      @item1.update(status: 1)
      @item3.update(status: 1)
      expect(@merchant.enabled_items).to match_array([@item1, @item3])
    end

    it '#top_five_items, returns a list of the top 5 items based on total revenu' do
      expect(@merchant2.top_five_items).to match_array([@item11, @item8, @item6, @item9, @item12])
    end

    it '#top_five_items, has attributes for tot_revenue invoice_items(unit_price * quantity)' do
      expect(@merchant2.top_five_items.first.tot_revenue).to eq(10043125)
      expect(@merchant2.top_five_items[1].tot_revenue).to eq(100000)
      expect(@merchant2.top_five_items[2].tot_revenue).to eq(40000)
      expect(@merchant2.top_five_items[3].tot_revenue).to eq(1000)
      expect(@merchant2.top_five_items[4].tot_revenue).to eq(100)
    end

    it 'switches merchant.enabled' do
      expect(@merchant.enabled?)
      @merchant.switch_enabled
      expect(!@merchant.enabled?)
      @merchant.switch_enabled
      expect(@merchant.enabled?)
    end

    it '#uniq_invoices' do
      expect(@merchant.uniq_invoices).to match_array([@invoice1, @invoice2, @invoice3, @invoice4, @invoice5, @invoice6])
      expect(@merchant2.uniq_invoices).to match_array([@invoice7, @invoice8, @invoice9, @invoice10, @invoice11, @invoice12, @invoice13])
    end

    it '#best_day' do
      expect(@merchant.best_day.class).to eq(ActiveSupport::TimeWithZone)
    end
  end
  

  describe 'model methods' do
    it '.enabled' do
      expect(Merchant.enabled.none?{|mer| mer.enabled == false})
    end
    
    it '.disabled' do
      expect(Merchant.disabled.none?{|mer| mer.enabled == true})
    end
  end
end
