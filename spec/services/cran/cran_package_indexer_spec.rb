require 'rails_helper'
require 'spec_helper.rb'

RSpec.describe Cran::CranPackageIndexer do
  describe "#get_packages" do
    context "when the packages can be downloaded" do
      it "returns the packages file" do
        expect(subject.get_packages).to be_a(Tempfile)
      end
    end

    context "when the packages cannot be downloaded" do
      it "returns nil" do
        allow(Down).to receive(:download).and_raise(StandardError)
        expect(subject.get_packages).to be_nil
      end
    end
  end

  describe '#get_package_names' do
    before do
      packages = subject.get_packages
      @package_names = subject.get_package_names(packages)
    end

    it 'returns an array of package names and versions' do
      expect(@package_names).not_to be_empty
      expect(@package_names.first).to include(:Package, :Version)
    end
  end

  describe "#get_package" do
    let(:package) { { "Package" => "A3", "Version" => "1.0.0" } }

    before do
      @indexer = Cran::CranPackageIndexer.new
    end

    context "when the package can be downloaded and parsed" do
      it "adds the package to the packages list" do
        allow(subject).to receive(:open).and_return(nil)
        allow(Zlib::GzipReader).to receive(:wrap).and_return(nil)
        allow(Archive::Tar::Minitar::Input).to receive(:open).and_return(nil)
        allow_any_instance_of(StringIO).to receive(:read).and_return("Package: A3\nVersion: 1.0.0\n")
        expect { subject.get_package(package) }.to change { subject.instance_variable_get(:@packages).length }.by(1)
      end
    end

    context "when the package cannot be downloaded or parsed" do
      it "returns nil" do
        allow(subject).to receive(:open).and_raise(StandardError)
        expect(subject.get_package(package)).to be_nil
      end
    end

    it 'returns a package with the correct information' do
      package = @indexer.get_package({:Package=>"A3", :Version=>"1.0.0"} ).first
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