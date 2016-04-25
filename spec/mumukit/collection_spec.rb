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

  let(:foo_id1) { { name: 'foo1', surname: 'bar1', id: id1 }.as_json }
  let(:foo_id2) { { name: 'foo2', surname: 'bar2', id: id2 }.as_json }
  let(:foo_id3) { { name: 'foo3', surname: 'bar3', id: id3 }.as_json }

  describe '#all' do
    let(:result) { Mumukit::Test::Foos.all.as_json[:foos] }

    it { expect(result.size).to eq(3) }
    it { expect(result.first).to eq(foo_id1) }
    it { expect(result.second).to eq(foo_id2) }
    it { expect(result.third).to eq(foo_id3) }
  end

  describe '#count' do
    it { expect(Mumukit::Test::Foos.count).to eq(3) }
  end

  describe '#exists?' do
    it { expect(Mumukit::Test::Foos.exists? id1).to be_truthy }
    it { expect(Mumukit::Test::Foos.exists? '1234').to be_falsey }
  end

  describe '#delete!' do
    context 'when id exists' do
      let!(:id) { Mumukit::Test::Foos.insert!({}.wrap_json)[:id] }
      it { expect(Mumukit::Test::Foos.delete!(id).documents.first['n']).to eq 1}
    end

    context 'when id does not exist' do
      let!(:id) { '1234' }
      it { expect(Mumukit::Test::Foos.delete!(id).documents.first['n']).to eq 0}
    end

  end

  describe '#find' do
    it { expect(Mumukit::Test::Foos.find(id1).as_json).to eq(foo_id1) }
    it { expect(Mumukit::Test::Foos.find('01')).to be_falsey }
  end

  describe '#find_by' do
    it { expect(Mumukit::Test::Foos.find_by({ name: 'foo1' }).as_json).to eq(foo_id1) }
    it { expect(Mumukit::Test::Foos.find_by({ name: 'foo4' }).as_json).to be_falsey }
  end

  describe '#find!' do
    it { expect(Mumukit::Test::Foos.find!(id1).as_json).to eq(foo_id1) }
    it { expect{Mumukit::Test::Foos.find!('01')}.to raise_error(Mumukit::Service::DocumentNotFoundError) }
  end

  describe '#find_by!' do
    it { expect(Mumukit::Test::Foos.find_by!({ name: 'foo1' }).as_json).to eq(foo_id1) }
    it { expect{Mumukit::Test::Foos.find_by!({ name: 'foo4' })}.to raise_error(Mumukit::Service::DocumentNotFoundError) }
  end

end