import psycopg2

class Psql:
  def __init__(self, user, password, db_name=None, autocommit=True):
    self.user = user 
    self.password = password 
    self.db_name = db_name

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

  def run(self, query, fetch=True, postprocess=True):
    with self.connection.cursor() as cursor:
      cursor.execute(query)
      res = cursor.fetchall() if fetch else []
    if not postprocess:
      return res
    new_res = []
    for x in res:
      tokens = x[0][1:-1].split(",")
      new_res.append((float(tokens[0]), int(float(tokens[1]))))
    return new_res





