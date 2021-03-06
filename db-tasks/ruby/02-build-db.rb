load './db_utils.rb'

# parameters
sql_scrip_path = '../sql/02-build-db.sql'
db_name = 'stock_data'
db_user = 'postgres'
db_pass = '123'

# loading the script for 'build-db'
sql_script = load_sql_script(sql_scrip_path)

# executing the script for 'build-db'
exec_sql_script_in_db(db_name, db_user, db_pass, sql_script)