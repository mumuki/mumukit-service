require 'spec_helper'

describe Mumukit::Service::Collection do

  after do
    Mumukit::Test::Database.clean!
  end

  let(:foo1) { Mumukit::Test::Foo.new({ name: 'foo1', surname: 'bar1' }) }
  let(:foo2) { Mumukit::Test::Foo.new({ name: 'foo2', surname: 'bar2' }) }
  let(:foo3) { Mumukit::Test::Foo.new({ name: 'foo3', surname: 'bar3' }) }

  let!(:id1) { Mumukit::Test::Foos.insert!(foo1)[:id] }
  let!(:id2) { Mumukit::Test::Foos.insert!(foo2)[:id] }
  let!(:id3) { Mumukit::Test::Foos.insert!(foo3)[:id] }

  describe '#all' do
    let(:result) { Mumukit::Test::Foos.all.as_json[:foos] }

    it { expect(result.size).to eq(3) }
    it { expect(result.first).to eq({ name: 'foo1', surname: 'bar1', id: id1 }.as_json) }
    it { expect(result.second).to eq({ name: 'foo2', surname: 'bar2', id: id2 }.as_json) }
    it { expect(result.third).to eq({ name: 'foo3', surname: 'bar3', id: id3 }.as_json) }
  end

end