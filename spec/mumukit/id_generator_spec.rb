require 'spec_helper'

describe Mumukit::Service::IdGenerator do
  it { expect(Mumukit::Service::IdGenerator.next.size).to eq 16 }
end
