class AddAttachmentImageToPictureProducts < ActiveRecord::Migration
  def self.up
    change_table :picture_products do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :picture_products, :image
  end
end
