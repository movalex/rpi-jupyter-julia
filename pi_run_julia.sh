IMAGE=${1:-'movalex/rpi-jupyter-julia:1.0.0'}
HOST_WORK_DIR=$HOME/docker/work

docker run -d --restart unless-stopped -p 8889:8888  --name jpj -v $HOME/.jupyter/jupyter_notebook_config.py:/home/jovyan/.jupyter/jupyter_notebook_config.py -v /etc/localtime:/etc/localtime:ro -v $HOST_WORK_DIR:/home/jovyan/work "$IMAGE"
