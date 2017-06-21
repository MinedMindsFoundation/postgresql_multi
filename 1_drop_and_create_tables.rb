# Example program to drop (delete) and create details and quotes tables

require 'pg'
load "./local_env.rb" if File.exists?("./local_env.rb")

begin

  # connect to the database
  db_params = {
        host: ENV['host'],  # AWS link
        port:ENV['port'],  # AWS port, always 5432
        dbname:ENV['dbname'],
        user:ENV['dbuser'],
        password:ENV['dbpassword']
      }
  conn = PG::Connection.new(db_params)

  # drop Timbersafe tables if exists
  # conn.exec "drop table if exists exposure_details"
  # conn.exec "drop table if exists info_details"
  # conn.exec "drop table if exists users"

  # drop details table if it exists
  conn.exec "drop table if exists details"

  # create the details table
  conn.exec "create table details (
             id bigserial primary key,
             name varchar(50),
             age int,
             image varchar(50))"

  # drop numbers table if it exists
  conn.exec "drop table if exists numbers"

  # create the numbers table with an implied foreign key (details_id)
  conn.exec "create table numbers (
             id bigserial primary key,
             details_id int,
             n1 int,
             n2 int,
             n3 int)"

  # drop quotes table if it exists
  conn.exec "drop table if exists quotes"

  # create the quotes table with an implied foreign key (details_id)
  conn.exec "create table quotes (
             id bigserial primary key,
             details_id int,
             quote varchar(255))"

rescue PG::Error => e

  puts 'Exception occurred'
  puts e.message

ensure

  conn.close if conn

end