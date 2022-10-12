class CreateRollbarTables < ActiveRecord::Migration[7.0]
  def change
    create_table :rollbar_tables do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
