require 'rails_helper'

RSpec.describe Load, type: :model do
  it { is_expected.to validate_presence_of(:code) }
end
