IMAGE=${1:-'movalex/rpi-jupyter-julia:latest'}
    HOST_WORK_DIR=$HOME/docker/work
    docker run -d -p 8888:8888\
    --name jp\
    -v /etc/localtime:/etc/localtime:ro\
    -v $HOST_WORK_DIR:/home/jovyan/work "$IMAGE"\
    -v $HOME/.jupyter/jupyter_notebook_config.py:/home/jovyan/.jupyter/jupyter_notebook_config.py
    
