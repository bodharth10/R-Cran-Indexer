module Cran
  class PackageExtractor
    CRAN_SERVER_URL = 'http://cran.r-project.org/src/contrib'

    def extract(package)
      begin
        package_object = {}
        url = "#{CRAN_SERVER_URL}/#{package[:Package]}_#{package[:Version]}.tar.gz"
        package_name = package[:Package]
        open(url) do |f|
          Zlib::GzipReader.wrap(f) do |gz|
            Archive::Tar::Minitar::Input.open(gz) do |tar|
              tar.each do |entry|
                next unless entry.full_name =~ /^#{package_name}\//
                next unless entry.file?
                if entry.name == "#{package_name}/DESCRIPTION"
                  content = entry.read
                  content.each_line {|line| package_object.merge!("#{(line.split.first)}": line.split(' ').drop(1).join(','))}
                end
              end
            end
          end
        end
        package_object.merge!(download_url: url)
      rescue StandardError => e
        Rails.logger.error "Failed to extract packages from CRAN: #{e}"
      end
    end
  end
end