class RemoveUnusedServiceEmails < ActiveRecord::Migration
  def change
    remove_column :services, :tech_support_email, :string
    remove_column :services, :admin_support_email, :string
  end
end
