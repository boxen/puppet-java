require 'spec_helper_acceptance'

describe 'java' do

  context 'basic include' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do

      pp = <<-EOS
      include java
      EOS

      # Run it twice and test for idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes  => true)
    end
  end
end
