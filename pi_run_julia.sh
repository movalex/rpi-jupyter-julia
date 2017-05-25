IMAGE=${1:-'movalex/rpi-jupyter-julia'}
HOST_WORK_DIR=$HOME/docker/work

docker run -d -p 8888:8888\
    --name jp_pi \
    -v /etc/localtime:/etc/localtime:ro \
    -v $HOME/.jupyter/jupyter_notebook_config.py:/home/jovyan/.jupyter/jupyter_notebook_config.py \
    -v $HOST_WORK_DIR:/home/jovyan/work "$IMAGE"
