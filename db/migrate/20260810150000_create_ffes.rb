class CreateFfes < ActiveRecord::Migration[8.2]
  def change
    create_table :ffes do |t|
      t.string :name, null: false
      t.string :description
      t.boolean :enabled, default: false
      t.datetime :expires_at
      # t.column :milieu, 'bit(4)', default: '0000' # only for PG

      t.timestamps
    end
  end
end
