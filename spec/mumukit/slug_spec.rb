require 'spec_helper'

describe Mumukit::Service::Slug do
  let(:repo) { Mumukit::Service::Slug.new('mumuki', 'functional-haskell-guide-1') }

  it 'webhook url is properly generated' do
    expect(repo.bibliotehca_guide_web_hook_url).to eq('http://bibliotheca.mumuki.io/guides/import/mumuki/functional-haskell-guide-1')
  end

  it 'book webhook url is properly generated' do
    expect(repo.bibliotehca_book_web_hook_url).to eq('http://bibliotheca.mumuki.io/books/import/mumuki/functional-haskell-guide-1')
  end

  it 'full name is properly generated' do
    expect(repo.to_s).to eq('mumuki/functional-haskell-guide-1')
  end

  it { expect { Mumukit::Service::Slug.from 'fo' }.to raise_error(Mumukit::Service::InvalidSlugFormatError) }
  it { expect { Mumukit::Service::Slug.from 'fo/bar' }.to_not raise_error }
end
