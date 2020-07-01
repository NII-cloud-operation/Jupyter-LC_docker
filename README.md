# Jupyter Notebook for *Literate Computing for Reproducible Infrastructure* [![Build Status](https://travis-ci.org/NII-cloud-operation/Jupyter-LC_docker.svg?branch=master)](https://travis-ci.org/NII-cloud-operation/Jupyter-LC_docker) [![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/yacchin1205/Jupyter-LC_docker/codt2020-demo)

Jupyter Notebook server which bundles a set of tools for *Literate Computing for Reproducible Infrastructure*.  This bundle shows how to implement robust and reliable operational procedure rather than explorative procedure within Jupyter’s GUI.

The goals for Literate Computing tools are:
* Preventing miss-operation; once a cell has been executed, it “freezes” against unintended execution.  Also you can “lock” cells for unintended modification.
* Adding a perspective into a notebook; markdown’s hierarchy is collapsible as document according to your focus.  However, embedded cells underneath are represented as dots and run through with a click as a routine procedure.
* Enables collaborative annotation onto Jupyter Notebooks, where your ideas and communications stay in context and grow.

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
docker run -it --rm -p 8888:8888 niicloudoperation/notebook
```

You can login the Notebook server with the authentication token in the startup message.

If you would like to use [NBSearch](https://github.com/NII-cloud-operation/nbsearch), use MongoDB container like the following:

```
docker run -d --rm --name nbsearch-mongodb mongo
docker run -it --rm --link nbsearch-mongodb:mymongo -e NBSEARCHDB_HOSTNAME=mymongo -p 8888:8888 niicloudoperation/notebook
```

To enable the NBSearch extension, refer `03_Notebookの検索.ipynb` in the container.

## Docker Options

You may customize the execution of Docker container and the Notebook server contained with the following optional arguments.

- `-e lc_wrapper_force=on` - Force summarizing mode of lc_wrapper (via env)
- `-e TZ=JST-9` - Specify the container timezone
- `-e PASSWORD=MY_UNBREAKABLE_PASS` - Set a initial password
- `-v /some/host/folder/for/work:/home/jovyan` - Mounts the host directory to the working directory in the container

### Using sidestickies

You can use [sidestickies](https://github.com/NII-cloud-operation/sidestickies) by the following steps.

- Add `-e SIDESTICKIES_SCRAPBOX_PROJECT_ID=value -e SIDESTICKIES_SCRAPBOX_COOKIE_CONNECT_SID=value` to docker options - Specify Scrapbox account to [sidestickies](https://github.com/NII-cloud-operation/sidestickies).
- Enable the sidestickies extension via the Nbextensions tab.
*Note: you need to enable both "Sidestickies for file tree" and "Sidestickies for notebook" nbextensions.*

### Using NBSearch

You can use [NBSearch](https://github.com/NII-cloud-operation/nbsearch) by enabling the NBSearch extension via the Nbextensions tab.
After the page of Jupyter is reloaded, the `NBSearch` tab appears on the page of Jupyter.

NBSearch uses MongoDB to store and search notebooks, and this image has a notebook which launch the MongoDB locally in the container.
If you would like to use your MongoDB for NBSearch instead of the local MongoDB, set the following environment variables to the options.

- `-e NBSEARCHDB_HOSTNAME=your_mongodb_hostname`, `-e NBSEARCHDB_PORT=your_mongodb_port` - Hostname and port of the MongoDB(default: `localhost:27017`)
- `-e NBSEARCHDB_USERNAME=your_mongodb_username`, `-e NBSEARCHDB_PASSWORD=your_mongodb_password` - Username and password of the MongoDB(if needed)
- `-e NBSEARCHDB_DATABASE=your_database_name` - Database name in the MongoDB(default: `nbsearch`)
- `-e NBSEARCHDB_COLLECTION=your_collection_name` - Collection name in the Database(default: `notebooks`)
- `-e NBSEARCHDB_BASE_DIR=your_notebook_home_dir` - Notebook directory to be searchable(default: `/home/$NB_USER`)
- `-e NBSEARCHDB_MY_SERVER_URL=your_notebook_server_url` - URL of my server, used to identify the notebooks on this server(default: `http://localhost:8888/`)
- `-e NBSEARCHDB_AUTO_UPDATE=1` - Launch lsyncd process to update the collection of MongoDB when local files are updated automatically
