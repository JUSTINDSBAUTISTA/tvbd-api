class CreateMovies < ActiveRecord::Migration[7.2]
  def change
    create_table :movies do |t|
      t.string :name
      t.string :slug
      t.string :image
      t.text :name_translations
      t.text :overview_translations
      t.text :aliases
      t.integer :score
      t.integer :runtime
      t.integer :status_id
      t.string :status_name
      t.string :status_record_type
      t.boolean :status_keep_updated
      t.datetime :last_updated
      t.string :year

      t.timestamps
    end
  end
end
