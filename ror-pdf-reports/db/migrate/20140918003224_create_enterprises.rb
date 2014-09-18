# generated with the following rails command:
# rails generate model enterprise enterprise_ticker:string{50} enterprise_name:string{100}
class CreateEnterprises < ActiveRecord::Migration
  def change
    create_table :enterprises do |t|
      t.string :enterprise_ticker, limit: 50
      t.string :enterprise_name, limit: 100

      t.timestamps
    end
  end
end
