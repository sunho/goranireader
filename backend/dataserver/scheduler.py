import nbformat
from nbconvert import HTMLExporter

nb = nbformat.read('../output.ipynb', as_version=4)
for cell in nb.cells:
    cell.metadata['hide_input'] = True

html_exporter = HTMLExporter()
html_exporter.template_file = 'basic'
(body, resources) = html_exporter.from_notebook_node(nb)
html_file_writer = open('asdf.html', 'wb')
html_file_writer.write(body.encode('utf-8'))
html_file_writer.close()

# import papermill as pm

# pm.execute_notebook(
    # 'jobs/cluster-books.ipynb',
    # 'out/output.ipynb',
    # parameters = dict(alpha=0.6, ratio=0.1)
# )


