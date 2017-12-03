require 'rails_helper'

RSpec.describe Genre, type: :model do
  it { should have_many(:movies) }
end
