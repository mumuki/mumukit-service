require 'spec_helper'

describe Mumukit::Service::Collection do

  after do
    Mumukit::Test::Database.clean!
  end

  describe 'simple operations' do
    let(:foo1) { Mumukit::Test::Foo.new({name: 'foo1', surname: 'bar1'}) }
    let(:foo2) { Mumukit::Test::Foo.new({name: 'foo2', surname: 'bar2'}) }
    let(:foo3) { Mumukit::Test::Foo.new({name: 'foo3', surname: 'bar3'}) }

    let!(:id1) { Mumukit::Test::Foos.insert!(foo1)[:id] }
    let!(:id2) { Mumukit::Test::Foos.insert!(foo2)[:id] }
    let!(:id3) { Mumukit::Test::Foos.insert!(foo3)[:id] }

    let(:foo_id1) { {name: 'foo1', surname: 'bar1'}.as_json }
    let(:foo_id2) { {name: 'foo2', surname: 'bar2'}.as_json }
    let(:foo_id3) { {name: 'foo3', surname: 'bar3'}.as_json }

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

    describe '#any?' do
      it { expect(Mumukit::Test::Foos.any?(name: 'foo1')).to be_truthy }
      it { expect(Mumukit::Test::Foos.any?(name: 'foo4')).to be_falsey }
    end

    describe '#exists?' do
      it { expect(Mumukit::Test::Foos.exists? id1).to be_truthy }
      it { expect(Mumukit::Test::Foos.exists? '1234').to be_falsey }
    end

    describe '#delete!' do
      context 'when id exists' do
        let!(:id) { Mumukit::Test::Foos.insert!({}.wrap_json)[:id] }
        it { expect(Mumukit::Test::Foos.delete!(id).documents.first['n']).to eq 1 }
      end

      context 'when id does not exist' do
        let!(:id) { '1234' }
        it { expect(Mumukit::Test::Foos.delete!(id).documents.first['n']).to eq 0 }
      end

    end

    describe '#find' do
      it { expect(Mumukit::Test::Foos.find(id1).as_json).to eq(foo_id1) }
      it { expect(Mumukit::Test::Foos.find('01')).to be_falsey }
    end

    describe '#find_by' do
      it { expect(Mumukit::Test::Foos.find_by({name: 'foo1'}).as_json).to eq(foo_id1) }
      it { expect(Mumukit::Test::Foos.find_by({name: 'foo4'}).as_json).to be_falsey }
    end

    describe '#find!' do
      it { expect(Mumukit::Test::Foos.find!(id1).as_json).to eq(foo_id1) }
      it { expect { Mumukit::Test::Foos.find!('01') }.to raise_error(Mumukit::Service::DocumentNotFoundError) }
    end

    describe '#find_by!' do
      it { expect(Mumukit::Test::Foos.find_by!({name: 'foo1'}).as_json).to eq(foo_id1) }
      it { expect { Mumukit::Test::Foos.find_by!({name: 'foo4'}) }.to raise_error(Mumukit::Service::DocumentNotFoundError) }
    end

    describe '#uniq' do
      before do
        Mumukit::Test::Foos.insert!({baz: {foo: 'foo1', bar: 'bar1'}}.wrap_json)
        Mumukit::Test::Foos.insert!({baz: {foo: 'foo1', bar: 'bar1'}}.wrap_json)
        Mumukit::Test::Foos.insert!({baz: {foo: 'foo1', bar: 'bar1'}}.wrap_json)
        Mumukit::Test::Foos.insert!({baz: {foo: 'foo1', bar: 'bar2'}}.wrap_json)
        Mumukit::Test::Foos.insert!({baz: {foo: 'foo1', bar: 'bar2'}}.wrap_json)
        Mumukit::Test::Foos.insert!({baz: {foo: 'foo2', bar: 'bar3'}}.wrap_json)
        Mumukit::Test::Foos.insert!({baz: {foo: 'foo2', bar: 'bar3'}}.wrap_json)
      end

      it { expect(Mumukit::Test::Foos.uniq('baz', {'baz.foo' => 'foo1'}, 'bar').as_json).
          to eq([{'foo' => 'foo1', 'bar' => 'bar1'}, {'foo' => 'foo1', 'bar' => 'bar2'}]) }
    end
  end

  describe 'complex operations' do
    before do
      Mumukit::Test::Foos.insert!({baz: {foo: 'foo1', bar: 'bar1'}}.wrap_json)
      Mumukit::Test::Foos.insert!({baz: {foo: 'foo1', bar: 'bar2'}}.wrap_json)
      Mumukit::Test::Foos.insert!({baz: {foo: 'foo2', bar: 'bar3'}}.wrap_json)
      Mumukit::Test::Foos.insert!({baz: {foo: 'foo2', bar: 'bar4'}}.wrap_json)
    end

    describe '#where' do
      it { expect(Mumukit::Test::Foos.where({'baz.foo' => 'foo1'}, {'baz.foo' => 0}).as_json[:foos].to_json).
          to eq([{baz: {bar: 'bar1'}}, {baz: {bar: 'bar2'}}].to_json) }
    end

    describe '#first_by' do
      it { expect(Mumukit::Test::Foos.first_by({'baz.foo' => 'foo1'}, {'baz.bar' => -1}, {'baz.foo' => 0}).to_json).
          to eq({baz: {bar: 'bar2'}}.to_json) }
    end

    describe '#order_by' do
      it { expect(Mumukit::Test::Foos.order_by({'baz.foo' => 'foo1'}, {'baz.bar' => -1}, {'baz.foo' => 0}).to_json).
          to eq({foos: [{baz: {bar: 'bar2'}}, {baz: {bar: 'bar1'}}]}.to_json) }
    end
  end

  describe 'upsert operations' do
    describe '#upsert_by!' do
      before { Mumukit::Test::Foos.upsert_by!(:zaraza, Mumukit::Test::Foo.new(zaraza: 5, foo: 6, bar: 6)) }
      before { Mumukit::Test::Foos.upsert_by!(:zaraza, Mumukit::Test::Foo.new(zaraza: 6, foo: 7, bar: 7)) }
      before { Mumukit::Test::Foos.upsert_by!(:zaraza, Mumukit::Test::Foo.new(zaraza: 5, foo: 4, bar: 4)) }

      it { expect(Mumukit::Test::Foos.count).to eq(2) }
      it { expect(Mumukit::Test::Foos.find_by!(zaraza: 5)).to json_like zaraza: 5, foo: 4, bar: 4 }
      it { expect(Mumukit::Test::Foos.find_by!(zaraza: 6)).to json_like zaraza: 6, foo: 7, bar: 7 }
    end
  end
end