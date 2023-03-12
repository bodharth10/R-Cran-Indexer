# require libraries

require 'open-uri'
require 'zlib'
require 'debian_control_parser'
require 'down'
require 'rubygems/package'
require 'archive/tar/minitar'

# define module
module Cran
  class CranPackageIndexer
    def initialize(limit = nil)
      @package_downloader = PackageDownloader.new
      @package_parser = PackageParser.new
      @package_indexer = PackageIndexer.new
      @limit = limit
    end
    
    # index_packages method to download, parse, and index package information
    def index_packages
      begin
        packages = @package_downloader.download
        package_names = @package_parser.parse(packages)
        @package_indexer.index_packages(package_names, @limit)
      rescue StandardError => e
      end
    end
  end
end
