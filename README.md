# Jupyter Notebook for *Literate Computing for Reproducible Infrastructure*

Jupyter Notebook server which bundles a set of tools for *Literate Computing for Reproducible Infrastructure*.  This bundle shows how to implement robust and reliable operational procedure rather than explorative procedure within Jupyter’s GUI.

## What it Gives You

- Jupyter Notebook 5.0.x
- Python2 kernel with LC_wrapper https://github.com/NII-cloud-operation/Jupyter-LC_wrapper
- Extensions
    - multi_outputs https://github.com/NII-cloud-operation/Jupyter-multi_outputs
    - run_through https://github.com/NII-cloud-operation/Jupyter-LC_run_through
    - nblineage https://github.com/NII-cloud-operation/Jupyter-LC_nblineage
    - i18n_cells https://github.com/NII-cloud-operation/Jupyter-i18n_cells

## Basic Use

You can start the Notebook server on port 8888 with the following command.

```
docker run -it --rm -p 8888:8888 niicloudoperation/notebook
```

You can login the Notebook server with the authentication token in the startup message. 

## Docker Options

You may customize the execution of Docker container and the Notebook server contained with the following optional arguments.

- `-e lc_wrapper_force=on` - Force summarizing and logging mode of lc_wrapper (via env)
- `-e TZ=JST-9` - Specify the container timezone
- `-v /some/host/folder/for/work:/notebooks` - Mounts the host directory to the working directory in the container
