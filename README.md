# Raspberry Pi Jupyter Docker Container for Data Scientists

Jupyter notebook with Python3 and Julia 1.0.0 for Raspberry Pi

This image is based on [https://github.com/movalex/rpi-jupyter-conda](https://github.com/movalex/rpi-jupyter-conda).
Build your own data-science Jupyter notebook on your Raspberry Pi. To use JupyterLab interface replace `tree` with `lab` in your notebook URL.

* Jupyter Notebook 5.4.x
* Conda Python 3.6.6 environment
* `gcc` preinstalled
* includes `curl, git, vim, tzdata, build-essential, gfortran, libzmq3, pkg-config`
* pandas, matplotlib, scipy, seaborn, scikit-learn, scikit-image, sympy, cython, statsmodel, cloudpickle, dill, bokeh, beautifulsoup4, pillow pre-installed
* Julia v1.0.0 with Gadfly, RDatasets, Distributions and PyPlot pre-installed and pre-compiled

This notebook server equipped with with Python 3.6.6 ([https://github.com/jjhelmus/berryconda](Berryconda3))
and it uses resin/rpi-raspbian:jessie as base image. These packages are preinstalled:

    cython flask h5py numexpr pandas pillow pycrypto pytables scikit-learn 
    scipy sqlalchemy sympy beautifulsoup4 bokeh cloudpickle dill matplotlib
    scikit-image seaborn statsmodels vincent xlrd nltk

You can easily install additional packages manually via `conda install` or `pip install`. This will work with unprivileged user, since all packages are installed in `opt/conda`, owned by this user.

Here's a [list of Conda packages](https://anaconda.org/rpi/repo) for Raspberry Pi (channel `rpi`).

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

By default only Python3 kernel is available. If you still want to use Python2 kernel, you can create Conda Python2 enviroment. Create new terminal window in Jupyter notebook (or login to bash session) and run: 

    conda create -n py27 python=2.7.14
    
Then activate new environment: 
    
    source activate py27
    
And install `ipykernel`:

    python2 -m pip install ipykernel
    
Finally add Python2 kernel to Jupyter Notebook and deactivate environment:

    python2 -m ipykernel install --user
    source deactivate py27
    
Reload Jupyter notebook page and new kernel will be available.
