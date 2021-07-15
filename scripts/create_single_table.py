#!/usr/bin/env python3

import argparse
from os.path import dirname, join
from socket import getfqdn

from argparse_logging import add_log_level_argument

from psqldb import Psql

CREATE_TYPES_SCRIPT = "create_types.sql"
CREATE_TABLE_SCRIPT = "create_table.sql"

parser = argparse.ArgumentParser()
parser.add_argument('-s', '--psql-server', action='store',
                    default=getfqdn() + ':5432',
                    help='URL as <host>:<port> of the Postgresql REST '
                         'interface.')
parser.add_argument('-u', '--user', action="store",
                    default="dan",
                    help="The username required to log into psql")
parser.add_argument('-P', '--password', action="store",
                    default="password",
                    help="The password required to log into psql")
parser.add_argument('-d', '--database', action="store",
                    default="",
                    help="The database required to log into psql")
parser.add_argument('--create-types', action='store_true',
                    help='If specified, creates the particle types')
parser.add_argument('-S', '--data-size', action='store',
                    default=1000, 
                    help='The size of the imported dataset')
parser.add_argument('-p', '--path', action='store',
                    default='/home/dan/data/garbage/iris-hep-benchmark-postgresql/data/Run2012B_SingleMu-1000.csv',
                    help='The path where the file is located')

add_log_level_argument(parser)
args = parser.parse_args()


conf = {
  "data_size": args.data_size,
  "data_path": args.path
}

# Start the process of creating the table
base_dir = dirname(__file__)
psql = Psql(args.user, args.password, args.database)

# Create types if necessary
if args.create_types:
  with open(join(base_dir, CREATE_TYPES_SCRIPT), "r") as f:
    query = f.read()
  psql.run(query, fetch=False)

# Create the requested table 
with open(join(base_dir, CREATE_TABLE_SCRIPT), "r") as f:
  query = f.read()
query = query % conf
psql.run(query, fetch=False)

# Close the executor
psql.close()