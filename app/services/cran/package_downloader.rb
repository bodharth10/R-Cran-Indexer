module Cran
  class PackageDownloader
    PACKAGE_URL = 'http://cran.r-project.org/src/contrib/PACKAGES.gz'
    def download
      begin
        Down.download(PACKAGE_URL)
      rescue StandardError => e
      end
    end
  end
end  