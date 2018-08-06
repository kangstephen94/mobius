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

class Transaction < ApplicationRecord
  validates :to, :from, :amount, presence: true
end
