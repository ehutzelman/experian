require 'test_helper'

describe Experian do

  before do
    stub_experian_uri_lookup
  end

  it "should refresh the ECALS url every 24 hours" do
    Experian.perform_ecals_lookup
    refute Experian.ecals_lookup_required?

    Timecop.travel(Time.now + 86500)
    assert Experian.ecals_lookup_required?

    Timecop.return
  end

end
