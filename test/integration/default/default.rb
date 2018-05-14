# # encoding: utf-8

# Inspec test for recipe drupal::lamp

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

unless os.windows?
    # This is an example test, replace with your own test.
    describe user('root'), :skip do
      it { should exist }
    end
  end
  
  # This is an example test, replace it with your own test.
  describe port(9080) do
    it { should be_listening }
  end
  describe http('http://localhost:9080/jsp-examples/jsp2/el/basic-arithmetic.jsp') do
    its('status') { should cmp 200 }
  end