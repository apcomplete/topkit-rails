require_relative '../../test_helper'

describe Topkit do
  it "is versioned" do
    Topkit::VERSION.wont_be_nil
  end
end
