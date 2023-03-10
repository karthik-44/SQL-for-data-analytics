
library(RPostgreSQL)

conn = dbConnect(PostgreSQL(),
  host = 'localhost',
  port = 5432,
  user= 'postgres',
  password = 'postgres',
  dbname = 'sqlda'  
)

result = dbGetQuery(conn, "select * from customers limit 10;")
