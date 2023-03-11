class Package < ApplicationRecord
  validates :name, :author, :publication, :maintainer, :license, :version, :title, presence: true
  validates_uniqueness_of :name

  def self.import_from_cran
    packages = Cran::CranPackageIndexer.new.index_packages
    packages.each do |pckg|
      package = find_or_initialize_by(name: pckg[:name])
      package.assign_attributes(
        version: pckg[:version],
        dependencies: pckg[:dependencies],
        title: pckg[:title],
        author: pckg[:author],
        publication: pckg[:publication],
        license: pckg[:license],
        maintainer: pckg[:maintainers]
      )
      package.save!
    end
  rescue StandardError => e
    Rails.logger.error "Failed to import packages from CRAN: #{e}"
  end
end