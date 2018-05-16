# Raspberry Pi Jupyter Docker Container for Data Scientists
------
Jupyter notebook with Python3 and Julia 0.6.2 for Raspberry Pi
This image is based on [https://github.com/movalex/rpi-jupyter-conda](https://github.com/movalex/rpi-jupyter-conda).
Build your own data-science Jupyter notebook on your Raspberry Pi. 

* Jupyter Notebook 5.2.x
* Conda Python 3.x environment
* gcc and g++ preinstalled
* pandas, matplotlib, scipy, seaborn, scikit-learn, scikit-image, sympy, cython, patsy, statsmodel, cloudpickle, dill, numba, bokeh, beautifulsoup4 pre-installed
* Julia v0.6.x with Gadfly, RDatasets, HDF5, Distributions and PyPlot pre-installed and pre-compiled

This notebook server equipped with with Python 3.6.3 (Berryconda3 for Raspberry Pi installation)
and it uses resin/rpi-raspbian:jessie as base image. These packages are installed:

You can also play with the latest JupyterLab, just replace `tree` to `lab` in notebook URL.

    cython flask h5py numexpr pandas pillow pycrypto pytables scikit-learn 
    scipy sqlalchemy sympy beautifulsoup4 bokeh cloudpickle dill matplotlib
    scikit-image seaborn statsmodels vincent xlrd nltk

You can easily install additional packages manually via `conda install` or `pip install`.
This will work with unprivileged user, since all packages are installed in `opt/conda`, owned by this user.

Here's a list of [all packages available](https://www.continuum.io/content/conda-support-raspberry-pi-2-and-power8-le) for Raspberry Pi via Conda:
    
    anaconda-client, argcomplete, astropy, bitarray, blist, boto, bsdiff4,
    cheetah (Python 2 only), conda, conda-build, configobj, cython, cytoolz,
    docutils, enum34 (Python 2 only), ephem, flask, grin (Python 2 only),
    h5py, ipython, jinja2, lxml, mercurial (Python 2 only), netcdf4, networkx,
    nltk, nose, numexpr, numpy, openpyxl, pandas, pillow, pip, ply, psutil,
    pycosat, pycparser, pycrypto, pycurl, pyflakes, pytables, pytest, python,
    python-dateutil, pytz, pyyaml, pyzmq (armv7l only), requests,
    scikit-learn (armv7l only), scipy (armv7l only), setuptools, six,
    sqlalchemy, sphinx, sympy, toolz, tornado, twisted, werkzeug, wheel
    

## Installation and run

* download image with Docker:
    
    ```docker pull movalex/rpi-jupyter-julia```

* To start container:

```
    IMAGE=${1:-'movalex/rpi-jupyter-julia:latest'}
    HOST_WORK_DIR=$HOME/docker/work
    docker run -d -p 8888:8888\
    --name jp -v /etc/localtime:/etc/localtime:ro\
    -v $HOST_WORK_DIR:/home/jovyan/work "$IMAGE"\
    -v $HOME/.jupyter/jupyter_notebook_config.py:/home/jovyan/.jupyter/jupyter_notebook_config.py
```

- change `$HOST_WORK_DIR` to whatever local folder you want save your jupyter documents.
- use `-v /etc/localtime:/etc/localtime:ro \` to syncronize your local date/time with image.
- add password protection to your Jupyter notebook by modifying `c.NotebookApp.password =` in `$HOME/.jupyter/jupyter_notebook_config.py`


## Login to bash session

To login a bash session use:

    docker exec -it <container id> /bin/bash

If you want to start bash session with root accesss so you could do more, use this command:

    docker exec -it -u 0 <container id> /bin/bash

## Python2 kernel

By default only Python3 kernel is available. If you still want to use Python2 kernel, you can create Conda Python2 enviroment. Just create new terminal window in Jupyter notebook (or login to bash session) and run: 

    conda create -n py27 python=2.7.14
    
Then activate new environment: 
    
    source activate py27
    
And install `ipykernel`:

    python2 -m pip install ipykernel
    
Finally add Python2 kernel to Jupyter Notebook and deactivate environment:

    python2 -m ipykernel install --user
    source deactivate py27
    
Reload Jupyter notebook page and new kernel will be available.
