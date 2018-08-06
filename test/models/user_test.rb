# == Schema Information
#
# Table name: users
#
#  id               :bigint(8)        not null, primary key
#  email            :string           not null
#  password_digest  :string           not null
#  session_token    :string           not null
#  activated        :boolean          default(FALSE), not null
#  activation_token :string           not null
#  credit           :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end