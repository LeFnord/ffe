# remove this migration, if you app already has a users model and table
class CreateUsers < ActiveRecord::Migration[8.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
