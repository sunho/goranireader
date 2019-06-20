FROM gorani-base

RUN pip3.6 install jupyter papermill

RUN pip3.6 install https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.13.1-cp36-cp36m-linux_x86_64.whl

