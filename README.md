# rpi-jupyter-julia
Jupyter notebook with Python3 and Julia 0.6.2 for Raspberry Pi

This image is based on [https://github.com/movalex/rpi-jupyter-conda](https://github.com/movalex/rpi-jupyter-conda).
Build your own data-science jupyter notebook on your Raspberry Pi. 
This notebook server equipped with with Python 3.6.3 (Berryconda3 for Raspberry Pi installation)
and it uses resin/rpi-raspbian:jessie as base image. These packages are installed:

    cython flask h5py numexpr pandas pillow pycrypto pytables scikit-learn 
    scipy sqlalchemy sympy beautifulsoup4 bokeh cloudpickle dill matplotlib
    scikit-image seaborn statsmodels vincent xlrd nltk

It also has latest [iJulia 0.6.2](https://julialang.org/) notebook with all incredible stuff it goes with.
Have fun making plots with your Raspberry Pi. `Pyplot`, `Distributions`, `HDF5` and `Rdatasets` packages are preinstalled and compiled.

You can easily install additional packages manually via `conda install` or `pip install`.
This will work with unprivileged user, since all packages are installed in `opt/conda`, owned by this user.

Here's a list of all packages available for Raspberry Pi via Conda:
    
    anaconda-client, argcomplete, astropy, bitarray, blist, boto, bsdiff4,
    cheetah (Python 2 only), conda, conda-build, configobj, cython, cytoolz,
    docutils, enum34 (Python 2 only), ephem, flask, grin (Python 2 only),
    h5py, ipython, jinja2, lxml, mercurial (Python 2 only), netcdf4, networkx,
    nltk, nose, numexpr, numpy, openpyxl, pandas, pillow, pip, ply, psutil,
    pycosat, pycparser, pycrypto, pycurl, pyflakes, pytables, pytest, python,
    python-dateutil, pytz, pyyaml, pyzmq (armv7l only), requests,
    scikit-learn (armv7l only), scipy (armv7l only), setuptools, six,
    sqlalchemy, sphinx, sympy, toolz, tornado, twisted, werkzeug, wheel

For further information see [Conda support for Raspberry Pi 2](https://www.continuum.io/content/conda-support-raspberry-pi-2-and-power8-le)

## Installation and run

* download image with Docker:
    
    ```docker pull movalex/rpi-jupyter-julia```

* you can also use `pi_run_julia.sh` file from this repository to start container:

    `sh pi_run_julia.sh`

    - Change `$HOST_WORK_DIR` to whatever folder you want to syncronize your docker container with.
    - use `-v /etc/localtime:/etc/localtime:ro \` to syncronize your local date/time with image.

    IMAGE=${1:-'movalex/rpi-jupyter-julia:0.6.2'}
    HOST_WORK_DIR=$HOME/docker/work
    docker run -d -p 8889:8888 --name jp -v /etc/localtime:/etc/localtime:ro -v $HOST_WORK_DIR:/home/jovyan/work "$IMAGE"