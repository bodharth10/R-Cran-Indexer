require 'json'
require 'open-uri'
require 'zlib'
require 'debian_control_parser'
require "down"
require 'rubygems/package'
require 'archive/tar/minitar'

module Cran
  class CranPackageIndexer
    PACKAGE_URL = 'http://cran.r-project.org/src/contrib/PACKAGES.gz'
    CRAN_SERVER_URL = "http://cran.r-project.org/src/contrib"

    def initialize
      @packages = []
    end

    def index_packages
      begin
        packages = get_packages
        package_names = get_package_names(packages)
        package_names.each do |pkg|
          package = get_package(pkg)
          @packages << package
        end
        @packages
      rescue StandardError => e
      end
    end
   
   # Download and decompress the packages
    def get_packages
      begin
        Zlib::GzipReader.new(Down.download(PACKAGE_URL)).read
      rescue StandardError => e
      end
    end

    # Parse the packages file and extract the required information ie name & versions
    def get_package_names(packages)
      begin
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
      rescue StandardError => e
      end
    end

    # package information by name
    def get_package(package)
      begin
        package_object = {}
        url = ("#{CRAN_SERVER_URL}/#{package[:Package]}_#{package[:Version]}.tar.gz")
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
      rescue StandardError => e
      end
    end
  end
end