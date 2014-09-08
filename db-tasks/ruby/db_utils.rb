require 'pg'

# basically reads all the text from a file and returns it as a string
def load_sql_script(script_path)
  # creating the result
  sql_script = ''

  # reading script lines
  lines = IO.readlines(script_path)

  # building script as a string
  lines.each{|line| sql_script += "#{line}"}

  # returning the script
  return sql_script
end


# basically executes a sql script in certain database
def exec_sql_script_in_db(db_name, db_user, db_pass, sql_script)
  # connecting to the given database
  conn = PG.connect(
      :dbname => db_name,
      :user => db_user,
      :password => db_pass)

  # actually executing the script
  conn.exec(sql_script)
end