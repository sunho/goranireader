import json
import argparse
parser = argparse.ArgumentParser()
parser.add_argument("notebook")
parser.add_argument("args")
parser.add_argument("kernel")
args = parser.parse_args()

import papermill as pm
import sys
params = json.loads(args.args)

pm.execute_notebook(
   '/home/'+args.notebook+'.ipynb',
   '/tmp/output.ipynb',
   kernel_name=args.kernel,
   parameters=params
)