# *Literate Computing for Reproducible Infrastructure* [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/n08u/Jupyter-LC_docker.git/sc-demo)

Jupyter Notebook server which bundles a set of tools for *Literate Computing for Reproducible Infrastructure*.  This bundle shows how to implement robust and reliable operational procedure rather than explorative procedure within Jupyter’s GUI.

The goals for Literate Computing tools are:
* Preventing miss-operation; once a cell has been executed, it “freezes” against unintended execution.  Also you can “lock” cells for unintended modification.
* Adding a perspective into a notebook; markdown’s hierarchy is collapsible as document according to your focus.  However, embedded cells underneath are represented as dots and run through with a click as a routine procedure.

## What it Gives You

- Jupyter Notebook 6.0.x
- Python3 and bash kernel with LC_wrapper https://github.com/NII-cloud-operation/Jupyter-LC_wrapper
- Extensions
    - multi_outputs https://github.com/NII-cloud-operation/Jupyter-multi_outputs
    - run_through https://github.com/NII-cloud-operation/Jupyter-LC_run_through
    - nblineage https://github.com/NII-cloud-operation/Jupyter-LC_nblineage
    - index https://github.com/NII-cloud-operation/Jupyter-LC_index
    - sidestickies https://github.com/NII-cloud-operation/sidestickies

## Basic Use

You can start the Notebook server on port 8888 with the following command.

```
docker run -it --rm -p 8888:8888 niicloudoperation/notebook:sc-demo
```

You can login the Notebook server with the authentication token in the startup message.

## Docker Options

You may customize the execution of Docker container and the Notebook server contained with the following optional arguments.

- `-e lc_wrapper_force=on` - Force summarizing mode of lc_wrapper (via env)
- `-e TZ=JST-9` - Specify the container timezone
- `-e PASSWORD=MY_UNBREAKABLE_PASS` - Set a initial password
- `-v /some/host/folder/for/work:/notebooks` - Mounts the host directory to the working directory in the container
- `-e SIDESTICKIES_SCRAPBOX_PROJECT_ID=value -e SIDESTICKIES_SCRAPBOX_COOKIE_CONNECT_SID=value` - Specify Scrapbox account to [sidestickies](https://github.com/NII-cloud-operation/sidestickies). You can enable sidestickies extension via the Nbextensions tab.
