FROM movalex/rpi-jupyter-conda:latest
USER root

RUN apt-get update && apt-get upgrade && apt-get install -y \
        curl \
        git \
        vim \
        tzdata \
        build-essential \
        libhdf5-dev \
        liblapack-dev \
        gfortran \
        libzmq3 \
        libfreetype6-dev \
        pkg-config \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
# g++ is required by matplotlib

#julia install
ENV JULIA_PATH /usr/local/julia

# https://julialang.org/juliareleases.asc
# Julia (Binary signing key) <buildbot@julialang.org>
ENV JULIA_GPG 3673DF529D9049477F76B37566E3C7DC03D6E495

# https://julialang.org/downloads/
ENV JULIA_VERSION 1.0.0

RUN set -ex; \
	\
# https://julialang.org/downloads/#julia-command-line-version
# https://julialang-s3.julialang.org/bin/checksums/julia-0.6.2.sha256
# this "case" statement is generated via "update.sh"
	dpkgArch="$(dpkg --print-architecture)"; \
	case "${dpkgArch##*-}" in \
		armhf) tarArch='armv7l'; dirArch='armv7l'; sha256='61e855e93c3bfe5e4f486a54a4c45194f4b020922e56af5fc104ff3fd3d8e41a' ;; \
		*) echo >&2 "error: current architecture ($dpkgArch) does not have a corresponding Julia binary release"; exit 1 ;; \
	esac; \
	\
	curl -fL -o julia.tar.gz     "https://julialang-s3.julialang.org/bin/linux/${dirArch}/${JULIA_VERSION%[.-]*}/julia-${JULIA_VERSION}-linux-${tarArch}.tar.gz"; \
	curl -fL -o julia.tar.gz.asc "https://julialang-s3.julialang.org/bin/linux/${dirArch}/${JULIA_VERSION%[.-]*}/julia-${JULIA_VERSION}-linux-${tarArch}.tar.gz.asc"; \
	\
	echo "${sha256} *julia.tar.gz" | sha256sum -c -; \
	\
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$JULIA_GPG"; \
	gpg --batch --verify julia.tar.gz.asc julia.tar.gz; \
	rm -rf "$GNUPGHOME" julia.tar.gz.asc; \
	\
	mkdir "$JULIA_PATH"; \
	tar -xzf julia.tar.gz -C "$JULIA_PATH" --strip-components 1; \
	rm julia.tar.gz

ENV PATH $JULIA_PATH/bin:$PATH

USER $NB_UID 

# Python packages for data science
RUN conda install --yes \
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
RUN echo "push!(Libdl.DL_LOAD_PATH, \"$CONDA_DIR/lib\")" > /home/$NB_USER/.juliarc.jl

# Add essential packages
RUN julia -e 'Pkg.add("PyPlot")' && julia -e 'Pkg.add("RDatasets")' && julia -e 'Pkg.add("Distributions")'  
RUN julia --startup-file=yes -e 'Pkg.add("HDF5")'

# Precompile Julia packages
RUN julia -e 'using IJulia' && \
    julia -e 'using RDatasets' && \
    julia -e 'using HDF5' && \
    julia -e 'using Distributions' && \
    julia -e 'using PyPlot'
