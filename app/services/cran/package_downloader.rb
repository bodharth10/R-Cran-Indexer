# define module
module Cran
  # PackageDownloader class definition
  class PackageDownloader
    PACKAGE_URL = 'http://cran.r-project.org/src/contrib/PACKAGES.gz'

    # download method to download package information from CRAN
    def download
      begin
        Down.download(PACKAGE_URL)
      rescue StandardError => e
        puts "Error downloading package: #{e.message}"
      end
    end
  end
end  