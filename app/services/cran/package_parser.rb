module Cran
  class PackageParser
    def parse(packages)
      begin
        package_json_arr = []
        package_list = DebianControlParser.new(Zlib::GzipReader.new(packages))
        package_list.paragraphs do |paragraph|
          package_json = {}
          paragraph.fields do |name, value|
            package_json.merge!("#{name}": value)
          end
          package_json_arr.push(package_json)
        end
        package_json_arr
      rescue StandardError => e
      end
    end
  end
end  