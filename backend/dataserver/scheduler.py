import papermill as pm

pm.execute_notebook(
   'jobs/feed-posts.ipynb',
   'out/output.ipynb',
   parameters = dict(alpha=0.6, ratio=0.1)
)
