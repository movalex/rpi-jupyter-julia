FROM movalex/rpi-jupyter-conda:latest
USER root
RUN apt-get update && apt-get install -y wget git
ENV NB_USER jovyan
ENV CONDA_DIR /opt/conda
ENV PATH $CONDA_DIR/bin:$PATH
ENV SHELL /bin/bash
ENV DEBIAN_FRONTEND noninteractive
ENV NB_UID 1000
ENV HOME /home/$NB_USER
# Required for pandas hdf5, sci-pi
RUN apt-get install -y libhdf5-dev liblapack-dev gfortran
#julia dependencies
RUN echo "deb http://ppa.launchpad.net/staticfloat/juliareleases/ubuntu trusty main" > /etc/apt/sources.list.d/julia.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3D3D3ACC && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    julia unzip \
    libnettle4 && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $NB_USER 
# Python packages for data science
RUN conda install --quiet --yes \
    'cython' \
    'flask' \
    'h5py' \
    'numexpr' \
    'pandas' \
    'pillow' \
    'pycrypto' \
    'pytables' \
    'scikit-learn' \
    'scipy' \
    'sqlalchemy' \
    'sympy'  && \
    conda clean -tipsy 

RUN pip install beautifulsoup4 bokeh cloudpickle dill matplotlib \
    scikit-image seaborn statsmodels vincent xlrd nltk
# Install IJulia packages as jovyan and then move the kernelspec out
# to the system share location. Avoids problems with runtime UID change not
# taking effect properly on the .local folder in the jovyan home dir.
RUN julia -e 'Pkg.add("IJulia")' && \
    mv $HOME/.local/share/jupyter/kernels/julia* $CONDA_DIR/share/jupyter/kernels/ && \
    chmod -R go+rx $CONDA_DIR/share/jupyter && \
    rm -rf $HOME/.local
# Show Julia where conda libraries are
# Add essential packages
RUN echo "push!(Libdl.DL_LOAD_PATH, \"$CONDA_DIR/lib\")" > /home/$NB_USER/.juliarc.jl

RUN julia -e 'Pkg.add("PyPlot")' && julia -e 'Pkg.add("RDatasets")' && julia -e 'Pkg.add("Distributions")'  
RUN julia --startup-file=yes -e 'Pkg.add("HDF5")'

# Precompile Julia pakcages

RUN julia -e 'using IJulia' && julia -e 'using RDatasets' && julia -e 'using HDF5' && julia -e 'using Distributions'  && julia -e 'using PyPlot'

