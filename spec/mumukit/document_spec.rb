require 'spec_helper'

describe Mumukit::Service::Document do

  describe 'writers' do
    let(:document) { {name: 'jon', surname: 'doe'}.to_document }

    before { document.name = 'john' }
    before { document['age'] = 21 }

    it { expect(document.name).to eq 'john' }
    it { expect(document.surname).to eq 'doe' }
    it { expect(document.age).to eq 21 }

    it { expect(document.as_json).to eq 'name' => 'john', 'surname' => 'doe', 'age' => 21 }
    it { expect(document.raw).to eq name: 'john', surname: 'doe', age: 21 }
  end

  describe 'readers' do
    context 'when only symbol keys' do
      let(:json) { {name: 'foo'} }

      it { expect(json.to_document.name).to eq 'foo' }
      it { expect(json.to_document.raw).to eq json }
    end

    context 'when string keys' do
      let(:json) { {'name' => 'foo'} }

      it { expect(json.to_document.name).to eq 'foo' }
      it { expect(json.to_document.raw).to eq json.symbolize_keys }
    end

  end
end
