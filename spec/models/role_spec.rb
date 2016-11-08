require 'rails_helper'

RSpec.describe Role, type: :model do
  describe 'associations for ...' do
    it do
      should have_and_belong_to_many(:users)
        .join_table('users_roles')
    end
  end
end
