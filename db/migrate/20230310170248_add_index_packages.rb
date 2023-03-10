class AddIndexPackages < ActiveRecord::Migration[6.1]
  def change
    add_index :packages, :name
  end
end
