require 'open-uri'
require 'zlib'
require 'debian_control_parser'
require 'down'
require 'rubygems/package'
require 'archive/tar/minitar'

module Cran
  class CranPackageIndexer
    def initialize
      @package_downloader = PackageDownloader.new
      @package_parser = PackageParser.new
      @package_indexer = PackageIndexer.new
    end

    def index_packages
      begin
        packages = @package_downloader.download
        package_names = @package_parser.parse(packages)
        @package_indexer.index_packages(package_names)
      rescue StandardError => e
      end
    end
  end
end
