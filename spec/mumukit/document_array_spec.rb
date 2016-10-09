require 'spec_helper'

describe Mumukit::Service::Document do
  let(:json) { {name: 'foo'} }

  it { expect(json.to_document.name).to eq 'foo' }
  it { expect(json.to_document.raw).to eq json }

end
