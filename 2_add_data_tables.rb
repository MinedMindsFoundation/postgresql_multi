# Example program to insert data into details and quotes tables

require 'pg'
load "./local_env.rb" if File.exists?("./local_env.rb")

begin

# ------- initialize user data sets, DB connection and ID -------

  # user data sets
  user_1 = ["John", 41, "user_1.png", 7, 11, 3, "Research is what I'm doing when I don't know what I'm doing."]
  user_2 = ["Jane", 51, "user_2.png", 1, 2, 3, "Life is 10% what happens to you and 90% how you react to it."]
  user_3 = ["Jim", 61, "user_3.png", 10, 20, 30, "In order to succeed, we must first believe that we can."]
  user_4 = ["Jill", 71, "user_4.png", 11, 22, 33, "It does not matter how slowly you go as long as you do not stop."]
  user_5 = ["June", 81, "user_5.png", 20, 40, 60, "Problems are not stop signs, they are guidelines."]
  user_6 = ["Jen", 91, "user_6.png", 2, 4, 6, "If you fell down yesterday, stand up today."]
  user_7 = ["Jeff", 101, "user_7.png", 37, 47, 87, "The way to get started is to quit talking and begin doing."]

  # aggregate user data into multi-dimensional array for iteration
  users = []
  users.push(user_1, user_2, user_3, user_4)

  # connect to the database
  db_params = {
        host: ENV['host'],  # AWS link
        port:ENV['port'],  # AWS port, always 5432
        dbname:ENV['dbname'],
        user:ENV['dbuser'],
        password:ENV['dbpassword']
      }
  conn = PG::Connection.new(db_params)

  # determine current max index (id) in details table
  max_id = conn.exec("select max(id) from details")[0]

  # set index variable based on current max index value
  max_id["max"] == nil ? v_id = 1 : v_id = max_id["max"].to_i + 1


# ------------------- load full user data sets -----------------------------


  # iterate through multi-dimensional users array for data
  users.each do |user|

    # initialize variables for SQL insert statements
    v_name = user[0]
    v_age = user[1]
    v_image = user[2]
    v_n1 = user[3]
    v_n2 = user[4]
    v_n3 = user[5]
    v_quote = user[6]

    # prepare SQL statement to insert user data into details table
    conn.prepare('q_statement',
                 "insert into details (id, name, age, image)
                  values($1, $2, $3, $4)")  # bind parameters

    # execute prepared SQL statement
    conn.exec_prepared('q_statement', [v_id, v_name, v_age, v_image])

    # deallocate prepared statement variable (avoid error "prepared statement already exists")
    conn.exec("deallocate q_statement")

    # prepare SQL statement to insert favorite numbers into numbers table
    conn.prepare('q_statement',
                 "insert into numbers (id, details_id, n1, n2, n3)
                  values($1, $2, $3, $4, $5)")  # bind parameters

    # execute prepared SQL statement
    conn.exec_prepared('q_statement', [v_id, v_id, v_n1, v_n2, v_n3])

    # deallocate prepared statement variable (avoid error "prepared statement already exists")
    conn.exec("deallocate q_statement")

    # prepare SQL statement to insert user quote into quotes table
    conn.prepare('q_statement',
                 "insert into quotes (id, details_id, quote)
                  values($1, $2, $3)")  # bind parameters

    # execute prepared SQL statement
    conn.exec_prepared('q_statement', [v_id, v_id, v_quote])

    # deallocate prepared statement variable (avoid error "prepared statement already exists")
    conn.exec("deallocate q_statement")

    # increment index value for next iteration
    v_id += 1

  end

# ---- load partial user data sets to demonstrate joins (inner/left/right) ----


  # load first partial user data set (user_5)

  w_name = user_5[0]
  w_n1 = user_5[3]
  w_n2 = user_5[4]
  w_n3 = user_5[5]

  # prepare SQL statement to insert user data into details table
  conn.prepare('q_statement',
               "insert into details (id, name)
                values($1, $2)")  # bind parameters

  # execute prepared SQL statement
  conn.exec_prepared('q_statement', [v_id, w_name])

  # deallocate prepared statement variable (avoid error "prepared statement already exists")
  conn.exec("deallocate q_statement")

  # prepare SQL statement to insert favorite numbers into numbers table
  conn.prepare('q_statement',
               "insert into numbers (id, details_id, n1, n2, n3)
                values($1, $2, $3, $4, $5)")  # bind parameters

  # execute prepared SQL statement
  conn.exec_prepared('q_statement', [v_id, v_id, w_n1, w_n2, w_n3])

  # deallocate prepared statement variable (avoid error "prepared statement already exists")
  conn.exec("deallocate q_statement")

  # # prepare SQL statement to insert user quote into quotes table
  # conn.prepare('q_statement',
  #              "insert into quotes (id, details_id, quote)
  #               values($1, $2, $3)")  # bind parameters

  # # execute prepared SQL statement
  # conn.exec_prepared('q_statement', [v_id, v_id, v_quote])

  # # deallocate prepared statement variable (avoid error "prepared statement already exists")
  # conn.exec("deallocate q_statement")

  v_id += 1


  # load second partial user data set (user_6)

  # initialize variables for SQL insert statements
  x_name = user_6[0]
  x_age = user_6[1]
  x_image = user_6[2]
  x_quote = user_6[6]

  # prepare SQL statement to insert user data into details table
  conn.prepare('q_statement',
               "insert into details (id, name, age, image)
                values($1, $2, $3, $4)")  # bind parameters

  # execute prepared SQL statement
  conn.exec_prepared('q_statement', [v_id, x_name, x_age, x_image])

  # deallocate prepared statement variable (avoid error "prepared statement already exists")
  conn.exec("deallocate q_statement")

  # prepare SQL statement to insert user quote into quotes table
  conn.prepare('q_statement',
               "insert into quotes (id, details_id, quote)
                values($1, $2, $3)")  # bind parameters

  # execute prepared SQL statement
  conn.exec_prepared('q_statement', [v_id, v_id, x_quote])

  # deallocate prepared statement variable (avoid error "prepared statement already exists")
  conn.exec("deallocate q_statement")

  v_id += 1


  # final partial user data set (user_7)

  # initialize variables for SQL insert statements
  y_name = user_7[0]
  y_age = user_7[1]
  y_n1 = user_7[3]
  y_quote = user_7[6]

  # prepare SQL statement to insert user data into details table
  conn.prepare('q_statement',
               "insert into details (id, name, age)
                values($1, $2, $3)")  # bind parameters

  # execute prepared SQL statement
  conn.exec_prepared('q_statement', [v_id, y_name, y_age])

  # deallocate prepared statement variable (avoid error "prepared statement already exists")
  conn.exec("deallocate q_statement")

  # prepare SQL statement to insert favorite numbers into numbers table
  conn.prepare('q_statement',
               "insert into numbers (id, details_id, n1)
                values($1, $2, $3)")  # bind parameters

  # execute prepared SQL statement
  conn.exec_prepared('q_statement', [v_id, v_id, y_n1])

  # deallocate prepared statement variable (avoid error "prepared statement already exists")
  conn.exec("deallocate q_statement")

  # prepare SQL statement to insert user quote into quotes table
  conn.prepare('q_statement',
               "insert into quotes (id, details_id, quote)
                values($1, $2, $3)")  # bind parameters

  # execute prepared SQL statement
  conn.exec_prepared('q_statement', [v_id, v_id, y_quote])

  # deallocate prepared statement variable (avoid error "prepared statement already exists")
  conn.exec("deallocate q_statement")

  v_id += 1

rescue PG::Error => e

  puts 'Exception occurred'
  puts e.message

ensure

  conn.close if conn

end