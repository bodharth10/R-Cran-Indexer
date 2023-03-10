class CreatePackages < ActiveRecord::Migration[6.1]
  def change
    create_table :packages do |t|
      t.string :name
      t.string :version
      t.string :title
      t.text :description
      t.string :maintainer
      t.string :license
      t.string :r_version_needed
      t.string :author
      t.datetime :publication
      t.string :dependencies

      t.timestamps
    end
  end
end
