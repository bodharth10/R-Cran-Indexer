module Cran
	class PackageIndexer
    def initialize(limit: nil)
	    @packages = []
	    @limit = limit
	  end

    def index_packages(package_info, limit = nil)
    	package_info = limit ? package_info.take(limit) : package_info
	    package_info.each_with_index do |package, index|	      
	      package_object = PackageExtractor.new.extract(package)
	      package = package_object.with_indifferent_access
	      @packages << {name: package['Package:'], title: package['Title:'], version: package['Version:'], author: package['Author:'], license: package['License:'], publication: package['Date/Publication:'], maintainers: package['Maintainer:'], dependencies: package['Depends:']}
	    end
	    @packages
	  end
  end
end