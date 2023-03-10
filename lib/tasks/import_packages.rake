#command: rake import_packages:run

namespace :import_packages do
  desc "Import packages from cran server"
  task :run => :environment do
    Package.import_from_cran()
  end
  puts "*** Task executed at #{Time.now} ****"
end