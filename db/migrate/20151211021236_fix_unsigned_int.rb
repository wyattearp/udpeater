class FixUnsignedInt < ActiveRecord::Migration
  def up
    change_column :messages, :dst_ip, :integer, :unsigned => true, :limit => 8
  end
  def down
    change_column :messages, :dst_ip, :integer
  end
end
