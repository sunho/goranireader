FROM ksunhokim/gorani-tf:v101

# RUN pip3.6 install numpy
# RUN apk add --no-cache \
#             --allow-untrusted \
#             --repository \
#              http://dl-3.alpinelinux.org/alpine/edge/testing \
#             hdf5 \
#             hdf5-dev && \
#     apk add --no-cache \
#         build-base
# RUN pip3.6 install --no-cache-dir --no-binary :all: tables h5py
# RUN apk --no-cache del build-base

# RUN pip3.6 install https://storage.googleapis.com/tensorflow/linux/gpu/tensorflow_gpu-1.13.1-cp36-cp36m-linux_x86_64.whl
