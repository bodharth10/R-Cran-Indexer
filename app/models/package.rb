class Package < ApplicationRecord
	validates :name, :author, :publication, :maintainer, :license, :version, :title, presence: true
  validates_uniqueness_of :name

  def self.import_from_cran
    packages = CranPackageIndexer.new().index_packages()
    packages.each do |pckg|
      package = self.find_or_initialize_by(name: pckg[:name])
      package.version = pckg[:version]
      package.dependencies = pckg[:dependencies]
      package.title = pckg[:title]
      package.author= pckg[:author]
      package.publication = pckg[:publication]
      package.license = pckg[:license]
      package.maintainer = pckg[:maintainers]
      package.save!
    end
  end
end
