class CreateMediators < ActiveRecord::Migration
  def change
    create_table(:mediators, primary_key: 'mediator_id') do |t|
      # name of the mediator
      t.string :mediator_name, limit: 40

      # timestamps placed by ActiveRecord
      t.timestamps
    end
  end
end
