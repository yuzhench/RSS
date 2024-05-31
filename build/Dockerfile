# Use an official NVIDIA CUDA image as base
FROM nvidia/cuda:12.2.0-base-ubuntu20.04

# Use non-interactive installation mode
ARG DEBIAN_FRONTEND=noninteractive

#use the python3
RUN apt-get update && apt-get install -y  python3 \
	python3-pip

# Install lsb_release utility
RUN apt-get update && apt-get install -y lsb-release


# # Install necessary packages
# RUN apt-get update && apt-get install -y \
#     cuda-command-line-tools-11-0 \
#     cuda-compiler-11-0 \
#     cuda-cudart-dev-11-0 \
#     cuda-tools-11-0 \
#     build-essential \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install --no-install-recommends -y curl

# Install ROS Noetic
# Setup sources.list
RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
# Setup keys
RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
# # Install ROS Noetic
RUN apt-get update && apt-get install -y ros-noetic-desktop-full && rm -rf /var/lib/apt/lists/*

#set the user
RUN useradd -m -s /bin/bash yuzhen
RUN apt-get update && apt-get install --no-install-recommends -y \
    vim  \
    nano \
	sudo 
#give the permission to the user 
RUN usermod -aG sudo yuzhen && \
    echo "yuzhen ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers


#specify the user
USER yuzhen


# # Install base utilities
# RUN apt-get update && apt-get install --no-install-recommends -y \
# 	wget \
#     clean \
# 	# build-essential 
# # Install miniconda
# ENV CONDA_DIR /opt/conda
# RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
#     /bin/bash ~/miniconda.sh -b -p /opt/conda



# # Put conda in path so we can use conda activate
# ENV PATH=$CONDA_DIR/bin:$PATH


###if you don't have this, then it can't modify your .bashrc file 
ENV SHELL=/bin/bash  

#set the working space
WORKDIR /home/yuzhen

#install nvcc 
RUN sudo apt install cuda-toolkit-12-2 -y
#write the path to the .bashrc
RUN echo "export PATH=/usr/local/cuda-12.2/bin:$PATH" >> /home/yuzhen/.bashrc



# #install the conda 
COPY manba.sh /home/yuzhen/RSS/resources/manba.sh 
# WORKDIR /home/yuzhen/RSS/resources
# RUN sudo chmod 777 manba.sh 
# RUN yes | ./manba.sh -b -p /home/yuzhen/manba
# WORKDIR /home/yuzhen

#copy the inside_docker.sh shell into the docker 
COPY inside_docker.sh /home/yuzhen/RSS/resources/inside_doceker.sh
COPY inside_docker_2.sh /home/yuzhen/RSS/resources/inside_doceker_2.sh

RUN cd ~/RSS/resources \
    && sudo chmod 777 manba.sh \
    && ./manba.sh -b \
    && eval "$(~/mambaforge/bin/conda shell.bash hook)" \
    && conda init

RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc

RUN exec bash

COPY environment.yml /home/yuzhen/RSS/resources/environment.yml
RUN cd ~/RSS/resources/ \
    && sudo chmod 777 environment.yml

COPY tensorrt_install.deb /home/yuzhen/RSS/resources/tensorrt_install.deb
RUN cd ~/RSS/resources/ \
    && sudo dpkg -i tensorrt_install.deb \
    && sudo cp /var/nv-tensorrt-local-repo-ubuntu2004-8.6.1-cuda-12.0/nv-tensorrt-local-9A1EDFBA-keyring.gpg /usr/share/keyrings/ \
    && eval "$(~/mambaforge/bin/conda shell.bash hook)" \
    && conda env create -f environment.yml
RUN eval "$(~/mambaforge/bin/conda shell.bash hook)" \
    && conda activate RSS \
    && pip install rospkg \
    && pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118 \
    && python3 -m pip install wheel \
    && pip install tensorrt==8.6.1 \
    && pip install empy \
    && sudo mkdir -p ~/RSS/catkin_ws/src \
    && sudo mkdir -p ~/RSS/resources \
    && sudo chmod 777 ~/RSS \
    && pip install pycuda \
    && pip install ultralytics \
    && pip install clip 

RUN eval "$(~/mambaforge/bin/conda shell.bash hook)" \
    && sudo apt update \
    && sudo apt install git -y\
    && sudo apt install wget -y\
    && cd ~/RSS/ \
    && sudo chmod 777 -R resources \
    && cd resources \
    && wget https://packages.microsoft.com/ubuntu/18.04/prod/pool/main/libk/libk4a1.4/libk4a1.4_1.4.1_amd64.deb \
    && wget https://packages.microsoft.com/ubuntu/18.04/prod/pool/main/libk/libk4a1.4-dev/libk4a1.4-dev_1.4.1_amd64.deb \
    && wget https://packages.microsoft.com/ubuntu/18.04/prod/pool/main/k/k4a-tools/k4a-tools_1.4.1_amd64.deb \
    && wget https://packages.microsoft.com/ubuntu/18.04/prod/pool/main/libk/libk4abt1.1/libk4abt1.1_1.1.2_amd64.deb \
    && wget https://packages.microsoft.com/ubuntu/18.04/prod/pool/main/libk/libk4abt1.1-dev/libk4abt1.1-dev_1.1.2_amd64.deb 


ENV ACCEPT_EULA=yes

RUN eval "$(~/mambaforge/bin/conda shell.bash hook)" \
    && cd ~/RSS/resources \
    && yes | sudo dpkg --install ./libk4a1.4_1.4.1_amd64.deb \
    && yes | sudo dpkg --install ./libk4a1.4-dev_1.4.1_amd64.deb \
    && sudo apt install -y  ./k4a-tools_1.4.1_amd64.deb \
    && yes | sudo dpkg --install ./libk4abt1.1_1.1.2_amd64.deb \
    && yes | sudo dpkg --install ./libk4abt1.1-dev_1.1.2_amd64.deb 

RUN eval "$(~/mambaforge/bin/conda shell.bash hook)" \
    && sudo chmod -R 777 ~/RSS/catkin_ws \
    && conda activate RSS

# RUN eval "$(~/mambaforge/bin/conda shell.bash hook)" \
#     && cd ~/RSS/resources \
#     && sudo apt install -y ./libk4a1.4_1.4.1_amd64.deb \
#     && sudo apt install -y ./libk4a1.4-dev_1.4.1_amd64.deb \
#     && sudo apt install -y ./k4a-tools_1.4.1_amd64.deb \
#     && sudo apt install -y ./libk4abt1.1_1.1.2_amd64.deb \
#     && sudo apt install -y ./libk4abt1.1-dev_1.1.2_amd64.deb 



#install the 





 
