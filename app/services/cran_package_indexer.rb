require 'json'
require 'open-uri'
require 'zlib'
require 'debian_control_parser'
require "down"
require 'rubygems/package'
require 'archive/tar/minitar'

class CranPackageIndexer
  PACKAGE_URL = 'http://cran.r-project.org/src/contrib/PACKAGES.gz'
  DOWNLOAD_URL = "http://cran.r-project.org/src/contrib"

  def initialize
    @packages = []
  end

  def index_packages
    packages = get_packages
    package_names = get_package_names(packages)
    package_names.each do |pkg|
      package = get_package(pkg)
      @packages << package
    end
    @packages
  end
 
 # Download and decompress the packages
  def get_packages
    Zlib::GzipReader.new(Down.download(PACKAGE_URL)).read
  end

  # Parse the packages file and extract the required information ie name & versions
  def get_package_names(packages)
    package_json_arr = []
    package_list = DebianControlParser.new(packages)
    package_list.paragraphs do |paragraph|
      puts "-----New Package Info-----"
      package_json = {}
      paragraph.fields do |name,value|
        puts "Name=#{name} / Value=#{value}"
        package_json.merge!({"#{name}": value})
      end
      package_json_arr.push(package_json)
    end
    package_json_arr
  end


  # package information by name
  def get_package(package)
    package_object = {}
    url = ("#{DOWNLOAD_URL}/#{package[:Package]}_#{package[:Version]}.tar.gz")
    package_name = package[:Package]
    open(url) do |f|
      Zlib::GzipReader.wrap(f) do |gz|
        Archive::Tar::Minitar::Input.open(gz) do |tar|
          tar.each do |entry|
            next unless entry.full_name =~ /^#{package_name}\//
            next unless entry.file?
            if entry.name == "#{package_name}/DESCRIPTION"
              content = entry.read
              content.each_line{|line|  package_object.merge!({"#{(line.split.first)}": line.split(" ").drop(1).join(",")})}
            end  
          end
        end
      end
    end
    package = package_object.with_indifferent_access
    { name: package["Package:"], title: package["Title:"], version: package["Version:"], author: package["Author:"], license: package["License:"], publication: package["Date/Publication:"] , maintainers: package["Maintainer:"], dependencies: package["Depends:"]}
  end

  def save_packages_in_db
    @packages.each do |pckg|
      package = Package.find_or_initialize_by(name: pckg[:name])
      package.version = pckg[:version]
      package.dependencies = pckg[:dependencies]
      package.title = pckg[:title]
      package.author= pckg[:author]
      package.publication = pckg[:publication]
      package.license = pckg[:license]
      package.maintainer = pckg[:maintainer]
      package.save
    end
  end  
end