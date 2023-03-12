class AddDownloadUrlToPackages < ActiveRecord::Migration[6.1]
  def change
    add_column :packages, :download_url, :string
  end
end
