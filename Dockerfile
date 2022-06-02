FROM nvcr.io/nvidia/tensorflow:22.04-tf1-py3

RUN echo "Custom container downloaded!"
RUN apt-get -y update --fix-missing
RUN apt-get -y install libopencv-highgui-dev ffmpeg libsm6 libxext6 software-properties-common
RUN pip install --upgrade pip

RUN mkdir /workspace/data
RUN mkdir /workspace/code
COPY .  /workspace/code
RUN echo "files copied to container"

RUN pip install whitebox==2.0.3
RUN pip install pillow
RUN pip install opencv-python==4.5.5.64
RUN pip install tifffile==2022.4.26
RUN pip install pandas==1.4.2
RUN pip install scikit-learn==1.0.2
RUN pip install imagecodecs
RUN echo "Installed python packages!"

RUN add-apt-repository ppa:ubuntugis/ppa && apt-get update
RUN apt-get install gdal-bin -y
RUN apt-get install libgdal-dev -y
RUN export CPLUS_INCLUDE_PATH=/usr/include/gdal
RUN export C_INCLUDE_PATH=/usr/include/gdal
RUN pip install GDAL
RUN echo "Gdal installed!"

# set up CRF
RUN ln -s /usr/local/lib/python3.8/dist-packages/tensorflow_core/libtensorflow_framework.so.1 /usr/local/lib/python3.8/dist-packages/tensorflow_core/libtensorflow_framework.so

WORKDIR /workspace/code/utils/crfasrnn_keras-gpu_support/src/cpp
RUN make clean
RUN make

WORKDIR /workspace/code/utils/crfasrnn_keras-master/src/cpp
RUN make clean
RUN make

WORKDIR /workspace/code

ENV PYTHONPATH="/workspace/code/utils/crfasrnn_keras-master/src:${PYTHONPATH}"
ENV LD_LIBRARY_PATH="/usr/local/lib/python3.8/dist-packages/tensorflow_core/:${LD_LIBRARY_PATH}"

