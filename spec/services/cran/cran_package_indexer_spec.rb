require 'rails_helper'
require 'spec_helper.rb'

describe Cran::CranPackageIndexer do
  before do
    @indexer = Cran::CranPackageIndexer.new
    @packages = @indexer.get_packages
  end


  describe '#get_packages' do
    it 'should returns packages' do
      expect(@packages).not_to be_empty
    end
  end

  describe '#get_package_names' do
    it 'returns an array of package names and versions' do
      package_names = @indexer.get_package_names(@packages)
      expect(package_names).not_to be_empty
      expect(package_names.first).to include(:Package, :Version)
    end
  end

  describe '#get_package' do
    it 'returns a package with the correct information' do
      package = @indexer.get_package({:Package=>"A3", :Version=>"1.0.0"} )
      expect(package[:name]).to eq('A3')
      expect(package[:version]).to eq('1.0.0')
      expect(package[:publication]).not_to be_empty
      expect(package[:author]).not_to be_empty
      expect(package[:license]).not_to be_empty
      expect(package[:maintainers]).not_to be_empty
      expect(package[:author]).not_to be_empty
    end
  end
end