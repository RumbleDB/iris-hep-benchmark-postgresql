import json
import psycopg2


STATS_COLS = {
  "userid",
  "dbid",
  "queryid",
  "query",
  "calls",
  "total_time",
  "min_time",
  "max_time",
  "mean_time",
  "stddev_time",
  "rows",
  "shared_blks_hit",
  "shared_blks_read",
  "shared_blks_dirtied",
  "shared_blks_written",
  "local_blks_hit",
  "local_blks_read",
  "local_blks_dirtied",
  "local_blks_written",
  "temp_blks_read",
  "temp_blks_written",
  "blk_read_time",
  "blk_write_time"
}


class Psql:
  def __init__(self, user, password, stats_path=None, db_name=None, 
    autocommit=True):
    self.user = user 
    self.password = password 
    self.db_name = db_name
    self.stats_path = stats_path if stats_path else "/data/query.log"

    if not self.db_name:
      self.connection = psycopg2.connect(user=self.user, 
                                         password=self.password)
    else:
      self.connection = psycopg2.connect(dbname=self.db_name,
                                         user=self.user, 
                                         password=self.password)

    self.connection.autocommit = autocommit

  def close(self):
    self.connection.close()

  def run(self, query):
    # Execute the query and get the results
    with self.connection.cursor() as cursor:
      cursor.execute(query)
      res = cursor.fetchall()

    # Make the results numpy compatible
    new_res = []
    for x in res:
      tokens = x[0][1:-1].split(",")
      new_res.append((float(tokens[0]), int(float(tokens[1]))))
    
    # Get the statistics around this query
    with self.connection.cursor() as cursor:
      cursor.execute("SELECT * FROM pg_stat_statements AS p WHERE p.query LIKE 'SELECT HISTOGRAM%' LIMIT 1;")
      res = cursor.fetchall()
      colnames = [desc[0] for desc in cursor.description]
    
    stats = {}
    for idx, stat in enumerate(res[0]):
      stats[colnames[idx]] = stat
    with open(self.stats_path, "w") as f:
      json.dump(stats, f)

    return (new_res, stats)

  
  def run_no_results(self, query):
    # Execute the query and get the results
    with self.connection.cursor() as cursor:
      cursor.execute(query)

