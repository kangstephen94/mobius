# == Schema Information
#
# Table name: transactions
#
#  id         :bigint(8)        not null, primary key
#  from       :integer          not null
#  to         :integer          not null
#  amount     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class TransactionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
