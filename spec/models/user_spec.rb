require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Devise modules' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:password_confirmation).on(:create) }
    it { should validate_presence_of(:password_confirmation).on(:update) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_length_of(:password).is_at_least(Devise.password_length.min).is_at_most(Devise.password_length.max).on(:create) }
    it { should have_db_index(:email).unique }
  end

  describe 'Devise JWT' do
    it { should respond_to(:jwt_payload) }
    it { should respond_to(:jwt_subject) }
  end
end
