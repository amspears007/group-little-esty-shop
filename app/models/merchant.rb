class Merchant < ApplicationRecord
  has_many :items
  has_many :invoice_items, through: :items
  has_many :invoices, through: :items
  has_many :customers, through: :invoices
  has_many :transactions, through: :invoices
  has_many :bulk_discounts

  def top_5_customers
    self.customers.joins(:transactions)
    .where(transactions: {result: 'success'})
    .select("customers.*, count(transactions.result) as transaction_count")
    .group(:id).order(transaction_count: :desc)
    .limit(5)
  end

  def items_ready_to_ship
    self.items.joins(:invoices)
    .where("invoice_items.status= 1")
    .select("items.*, invoice_items.invoice_id, invoices.created_at as invoice_creation")
    .distinct
    .order(invoice_creation: :desc)
  end

  def disabled_items
    items.where(status: 0)
  end

  def enabled_items
    items.where(status: 1)
  end

  def top_five_items
    items.joins(invoices: :transactions)
    .where(transactions: {result: 'success'})
    .select("items.*, sum(invoice_items.unit_price * invoice_items.quantity) as tot_revenue")
    .group(:id)
    .order(tot_revenue: :desc)
    .limit(5)
  end

  def switch_enabled
    update(enabled: !enabled)
  end

  def self.enabled
    where(enabled: :true)
  end

  def self.disabled
    where(enabled: :false)
  end

  def uniq_invoices
    invoices.distinct
  end

  def self.top_five
        joins(invoices: :transactions)
        .where('transactions.result = ?', 'success')
        .select("merchants.id, merchants.name, SUM(invoice_items.unit_price * invoice_items.quantity) as tot_revenue")
        .group("merchants.id")
        .order("tot_revenue desc")
        .limit(5)
  end

  def invoice_items_data(invoice_id)
    invoice_items
    .select("invoice_items.*, items.name")
    .where(invoice_id: invoice_id)
    .distinct
  end

  def inv_total_rev(invoice_id)
    invoice_items.where(invoice_items: {invoice_id: invoice_id})
    .sum("invoice_items.quantity * invoice_items.unit_price")
  end

  def best_day
    invoices.joins(:invoice_items)
    .group('invoices.created_at')
    .order('sum(invoice_items.quantity * invoice_items.unit_price) desc, invoices.created_at desc')
    .limit(1)
    .pluck('invoices.created_at').first
  end
end
