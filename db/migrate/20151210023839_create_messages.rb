class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.integer :dst_ip
      t.integer :dst_port
      t.boolean :async
      t.boolean :msg_raw
      t.binary :message_data
      t.binary :message_response

      t.timestamps null: false
    end
  end
end
