class CreateFeatureFlags < ActiveRecord::Migration[8.2]
  def change
    create_table :feature_flags do |t|
      t.string :name, null: false
      t.string :description
      t.boolean :enabled, default: false
      t.datetime :expires_at
      t.column :milieu, 'bit(4)', default: '0000' # only for PG
      t.text :user_ids, array: true, default: []

      t.timestamps
    end

    add_index :feature_flags, :name, unique: true
    add_index :feature_flags, :user_ids, using: :gin
  end
end
