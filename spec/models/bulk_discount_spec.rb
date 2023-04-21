require 'rails_helper'

RSpec.describe BulkDiscount, model: :type do
  it { should belong_to(:merchant) }

end