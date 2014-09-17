# generated with the following rails command:
# rails generate model enterprise enterprise_ticker:string{50} enterprise_name:string{100}
class CreateEnterprises < ActiveRecord::Migration
  def change
    create_table(:enterprises, primary_key: 'enterprise_id') do |t|
      # ticker of the enterprise
      t.string :enterprise_ticker, limit: 50

      # name of the enterprise
      t.string :enterprise_name, limit: 100

      # timestamps placed by ActiveRecord
      t.timestamps
    end
  end
end
