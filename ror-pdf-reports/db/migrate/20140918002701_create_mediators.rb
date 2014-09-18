# generated with the following rails command:
# rails generate model mediator mediator_name:string{40}
class CreateMediators < ActiveRecord::Migration
  def change
    create_table :mediators do |t|
      t.string :mediator_name, limit: 40

      t.timestamps
    end
  end
end
