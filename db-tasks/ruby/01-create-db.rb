load './db_utils.rb'

# parameters
sql_scrip_path = '../sql/01-create-db.sql'
db_name = 'postgres'
db_user = 'postgres'
db_pass = '123'

# loading the script for 'create-db'
sql_script = load_sql_script(sql_scrip_path)

# executing the script for 'create-db'
exec_sql_script_in_db(db_name, db_user, db_pass, sql_script)