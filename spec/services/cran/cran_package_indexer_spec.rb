require 'spec_helper'
require 'stringio'

RSpec.describe Cran::PackageDownloader do
  let(:package_downloader) { Cran::PackageDownloader.new }

  describe '#download' do
    context 'when PACKAGE_URL is valid' do
      before do
        allow(Down).to receive(:download).and_return(StringIO.new(''))
      end

      it 'downloads the package file' do
        expect(package_downloader.download).to be_an_instance_of StringIO
      end
    end
  end
end

RSpec.describe Cran::PackageParser do
  let(:package_parser) { Cran::PackageParser.new }
  let(:packages) { StringIO.new("Package: Package: A3\nVersion: 1.0.0\n") }

  describe '#parse' do
    it 'parses the package list' do
      expect(package_parser.parse(packages)) == ([
        { 'Package': 'A3', 'Version': '1.0.0' },
      ])
    end
  end
end

RSpec.describe Cran::PackageExtractor do
  let(:package_extractor) { Cran::PackageExtractor.new }
  let(:package) { { 'Package': 'A3', 'Version': '1.0.0' } }

  describe '#extract' do
    context 'when package URL is valid' do
      before do
        allow(package_extractor).to receive(:open).and_return(StringIO.new(''))
      end

      it 'extracts the package' do
        expect(package_extractor.extract(package)).to be_an_instance_of Hash
      end
    end
  end
end

RSpec.describe Cran::PackageIndexer do
  let(:package_indexer) { Cran::PackageIndexer.new }
  let(:package_info) { [{ 'Package': 'A3', 'Version': '1.0.0' }] }

  describe '#index_packages' do
    before do
      allow_any_instance_of(Cran::PackageExtractor).to receive(:extract).and_return({:"Package:"=>"A3", :"Type:"=>"Package", :"Title:"=>"Accurate,,Adaptable,,and,Accessible,Error,Metrics,for,Predictive", :Models=>"", :"Version:"=>"1.0.0", :"Date:"=>"2015-08-15", :"Author:"=>"Scott,Fortmann-Roe", :"Maintainer:"=>"Scott,Fortmann-Roe,<scottfr@berkeley.edu>", :"Description:"=>"Supplies,tools,for,tabulating,and,analyzing,the,results,of,predictive,models.,The,methods,employed,are,applicable,to,virtually,any,predictive,model,and,make,comparisons,between,different,methodologies,straightforward.", :"License:"=>"GPL,(>=,2)", :"Depends:"=>"R,(>=,2.15.0),,xtable,,pbapply", :"Suggests:"=>"randomForest,,e1071", :"NeedsCompilation:"=>"no", :"Packaged:"=>"2015-08-16,14:17:33,UTC;,scott", :"Repository:"=>"CRAN", :"Date/Publication:"=>"2015-08-16,23:05:52"})
    end

    it 'indexes the packages' do
      expect(package_indexer.index_packages(package_info)) == ({:name=>"A3", :title=>"Accurate,,Adaptable,,and,Accessible,Error,Metrics,for,Predictive", :version=>"1.0.0", :author=>"Scott,Fortmann-Roe", :license=>"GPL,(>=,2)", :publication=>"2015-08-16,23:05:52", :maintainers=>"Scott,Fortmann-Roe,<scottfr@berkeley.edu>", :dependencies=>"R,(>=,2.15.0),,xtable,,pbapply"})
    end
  end
end      