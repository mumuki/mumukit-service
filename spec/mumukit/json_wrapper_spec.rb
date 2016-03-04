require 'spec_helper'

describe Mumukit::Service::JsonWrapper do
  let(:json) { {name: 'foo'} }

  it { expect(json.wrap_json.name).to eq 'foo' }
  it { expect(json.wrap_json.raw).to eq json }

end
