module Cran
	class PackageIndexer
    def initialize
      @packages = []
    end

    def index_packages(package_info)
      package_info.first(2).each do |package|
        package_object = PackageExtractor.new.extract(package)
        package = package_object.with_indifferent_access
        @packages << {name: package['Package:'], title: package['Title:'], version: package['Version:'], author: package['Author:'], license: package['License:'], publication: package['Date/Publication:'], maintainers: package['Maintainer:'], dependencies: package['Depends:'], download_url: package[:download_url]}
      end
      @packages
    end
  end
end