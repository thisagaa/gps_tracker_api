class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events, id: false do |t| # prevents adding unnecessary id column
      t.string :uuid, primary_key: true
      t.datetime :recorded_at, null: false # all null:false ensures that these are critical fields
      t.datetime :received_at, null: false
      t.string :category, null: false
      t.string :device_uuid, null: false
      t.jsonb :metadata, default: {}
      t.boolean :notification_sent, default: false
      t.boolean :is_deleted, default: false # avoiding permanent deletion of records. future queries will only ignore records and wont lose historical data

      t.timestamps # automatically creates "created_at" and "updated_at" timestamps
    end
  end
end
