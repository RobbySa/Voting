class CreateVotes < ActiveRecord::Migration[7.0]
  def change
    create_table :votes do |t|
      t.integer :epoch
      t.string :validity
      t.references :campaign, null: false, foreign_key: true
      t.string :choice

      t.timestamps
    end
  end
end
