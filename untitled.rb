require 'open-uri'
require 'zlib'
require 'debian_control_parser'
require 'json'
require "down"
require 'rubygems/package'
require 'open-uri'
require 'zlib'
require 'archive/tar/minitar'


packages_url = 'http://cran.r-project.org/src/contrib/PACKAGES.gz'

# Download and decompress the packages file
packages = Zlib::GzipReader.new(Down.download(packages_url)).read

# Parse the packages file and extract the required information
package_list = DebianControlParser.new(packages)

package_json_arr = []
package_list.paragraphs do |paragraph|
  puts "-----New Package Info-----"
  package_json = {}
  paragraph.fields do |name,value|
    puts "Name=#{name} / Value=#{value}"
    package_json.merge!({"#{name}": value})
  end
  package_json_arr.push(package_json)
end
# Convert the package information to a JSON file
File.open('packages.json', 'w') do |f|
  f.write(JSON.generate(package_json_arr))
end

package_object = {}

package_json_arr.first(10).each do |package_json|
  download_url= "http://cran.r-project.org/src/contrib"
  url = ("#{download_url}/#{package_json[:Package]}_#{package_json[:Version]}.tar.gz")
  package_name = package_json[:Package]

  open(url) do |f|
    Zlib::GzipReader.wrap(f) do |gz|
      Archive::Tar::Minitar::Input.open(gz) do |tar|
        tar.each do |entry|
          next unless entry.full_name =~ /^#{package_name}\//
          next unless entry.file?

          # Do something with the file, for example:
          if entry.name == "#{package_name}/DESCRIPTION"
            content = entry.read
            content.each_line{|line|  package_object.merge!({"#{(line.split.first)}": line.split[1]})}
          end  
        end
      end
    end
  end
end

package_object































package_json_arr.first(5).each do |package_json|
  download_url= "http://cran.r-project.org/src/contrib"
  # package = Zlib::GzipReader.new(Down.download("#{download_url}/#{package_json[:Package]}_#{package_json[:Version]}.tar.gz")).read
  tar_extract = Gem::Package::TarReader.new(Zlib::GzipReader.open(Down.download("#{download_url}/#{package_json[:Package]}_#{package_json[:Version]}.tar.gz/DESCRIPTION")))
  tar_extract.rewind # The extract has to be rewinded after every iteration
  tar_extract.each do |entry|
    puts entry.read
  end
  tar_extract.close
end


Zlib::GzipReader.open(Down.download("#{download_url}/#{package_json[:Package]}_#{package_json[:Version]}.tar.gz/DESCRIPTION")) do |gz|
  Gem::Package::TarReader.new(gz) do |tar|
    tar.each do |entry|
      if entry.full_name == filename_to_extract
        File.open(filename_to_extract, 'wb') do |f|
          f.write(entry.read)
        end
        break
      end
    end
  end
end



DESCRIPTION


