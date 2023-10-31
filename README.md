# Jupyter Notebook for *Literate Computing for Reproducible Infrastructure* [![Build Status](https://travis-ci.org/NII-cloud-operation/Jupyter-LC_docker.svg?branch=master)](https://travis-ci.org/NII-cloud-operation/Jupyter-LC_docker) [![badge](https://img.shields.io/badge/launch-binder-579ACA.svg?logo=data:image/png;base64,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)](https://mybinder.org/v2/gh/NII-cloud-operation/Jupyter-LC_docker/master?urlpath=tree)

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
    - nbsearch https://github.com/NII-cloud-operation/nbsearch

## Basic Use

You can start the Notebook server on port 8888 with the following command.

```
docker run -it --rm -p 8888:8888 niicloudoperation/notebook
```

You can login the Notebook server with the authentication token in the startup message.

If you would like to use [NBSearch](https://github.com/NII-cloud-operation/nbsearch), use Solr container like the following:

```
# Launch Solr
git clone https://github.com/NII-cloud-operation/nbsearch /tmp/nbsearch
docker run -d --name nbsearch-solr -v /tmp/nbsearch:/tmp/nbsearch --rm solr:8 \
    bash -c "precreate-core jupyter-notebook /tmp/nbsearch/solr/jupyter-notebook/ && \
        precreate-core jupyter-cell /tmp/nbsearch/solr/jupyter-cell/ && \
        solr-foreground"

# Launch MinIO
docker run -d --rm -e MINIO_ACCESS_KEY=nbsearchak -e MINIO_SECRET_KEY=nbsearchsk \
    --name nbsearch-minio minio/minio:latest server /data --compat

# Launch Notebook
docker run -it --rm --link nbsearch-solr:solr --link nbsearch-minio:minio \
    -e NBSEARCHDB_SOLR_BASE_URL=http://solr:8983 -e NBSEARCHDB_S3_ENDPOINT_URL=http://minio:9000 \
    -e NBSEARCHDB_S3_ACCESS_KEY=nbsearchak -e NBSEARCHDB_S3_SECRET_KEY=nbsearchsk \
    -p 8888:8888 niicloudoperation/notebook
```

To enable the NBSearch extension, refer `03_Notebookの検索.ipynb` in the container.

## Docker Options

You may customize the execution of Docker container and the Notebook server contained with the following optional arguments.

- `-e lc_wrapper_force=on` - Force summarizing mode of lc_wrapper (via env)
- `-e TZ=JST-9` - Specify the container timezone
- `-e PASSWORD=MY_UNBREAKABLE_PASS` - Set a initial password
- `-v /some/host/folder/for/work:/home/jovyan` - Mounts the host directory to the working directory in the container

### Using sidestickies

You can use [sidestickies](https://github.com/NII-cloud-operation/sidestickies) by either of the following steps.

Using Scrapbox https://scrapbox.io/:
- Add `-e SIDESTICKIES_SCRAPBOX_PROJECT_ID=value -e SIDESTICKIES_SCRAPBOX_COOKIE_CONNECT_SID=value` to docker options - Specify Scrapbox account to [sidestickies](https://github.com/NII-cloud-operation/sidestickies).
- Enable the sidestickies extension via the Nbextensions tab.
*Note: you need to enable both "Sidestickies for file tree" and "Sidestickies for notebook" nbextensions.*

Using ep_weave(Etherpad) https://github.com/NII-cloud-operation/ep_weave :
- Add `-e SIDESTICKIES_EP_WEAVE_URL=http://ep_weave:9001 -e SIDESTICKIES_EP_WEAVE_API_KEY=YOUR_ETHERPAD_APIKEY` to docker options.
- Enable the sidestickies extension via the Nbextensions tab.
*Note: you need to enable both "Sidestickies for file tree" and "Sidestickies for notebook" nbextensions.*

### Using NBSearch

You can use [NBSearch](https://github.com/NII-cloud-operation/nbsearch) by enabling the NBSearch extension via the Nbextensions tab.
After the page of Jupyter is reloaded, the `NBSearch` tab appears on the page of Jupyter.

NBSearch uses Solr and S3 Compatible Storage to store and search notebooks.
You will be able to use NBSearch once you set up your Solr and S3 compatible storage configurations, set the following environment variables to the options.

- `-e NBSEARCHDB_SOLR_BASE_URL=your_solr_url` - The base URL of Solr(default: `http://localhost:8983`)
- `-e NBSEARCHDB_SOLR_BASIC_AUTH_USERNAME=your_solr_username`, `-e NBSEARCHDB_SOLR_BASIC_AUTH_PASSWORD=your_solr_password` - The username and password for Solr(if needed)
- `-e NBSEARCHDB_S3_ENDPOINT_URL=your_database_name` - The URL of S3(default: http://localhost:9000)
- `-e NBSEARCHDB_S3_ACCESS_KEY=your_s3_access_key`, `-e NBSEARCHDB_S3_SECRET_KEY=your_s3_secret_key` - The access key and secret key for S3(required)
- `-e NBSEARCHDB_S3_REGION_NAME=your_s3_region_name` - The region name of S3(if needed)
- `-e NBSEARCHDB_S3_BUCKET_NAME=your_s3_bucket_name` - The bucket on S3(required)
- `-e NBSEARCHDB_SOLR_NOTEBOOK=your_solr_notebook_core` - The core for notebooks on Solr(default: `jupyter-notebook`)
- `-e NBSEARCHDB_SOLR_CELL=your_solr_cell_core` - The core for cells on Solr(default: `jupyter-cell`)
- `-e NBSEARCHDB_BASE_DIR=your_notebook_home_dir` - Notebook directory to be searchable(default: `/home/$NB_USER`)
- `-e NBSEARCHDB_MY_SERVER_URL=your_notebook_server_url` - URL of my server, used to identify the notebooks on this server(default: `http://localhost:8888/`)
- `-e NBSEARCHDB_AUTO_UPDATE=1` - Launch lsyncd process to update the index of Solr when local files are updated automatically
- `-e NBSEARCHDB_OWNER=username` - The value of owner field for updating solr index(default: the value of environment variable `JUPYTERHUB_USER` or `NB_USER`)
- `-e NBSEARCHDB_UPDATE_INDEX_OPT` - Options for the `update-index` NBSearch command invoked by the lsyncd process

### Using NBWhisper

You can use [NBWhisper](https://github.com/NII-cloud-operation/nbwhisper) by enabling the NBWhisper extension via the Nbextensions tab.

To use NBWhisper, you need an API token of the SkyWay (WebRTC) service. It can be specified from environment variables as follows.
(For more information, see https://github.com/NII-cloud-operation/nbwhisper/ .)

- `-e NBWHISPER_SKYWAY_API_TOKEN` - An api token for SkyWay. This nbextension is not compatible with new SkyWay service, but old one. You can get an api token from your old SkyWay admin page. https://console-webrtc-free.ecl.ntt.com/users/login
- `-e NBWHISPER_ROOM_MODE_FOR_WAITING_ROOM` - Room mode for waiting room. Input "sfu" or "mesh" as waiting room mode you want to use.
- `-e NBWHISPER_ROOM_MODE_FOR_TALKING_ROOM` - Room mode for talking room. Input "sfu" or "mesh" as talking room mode you want to use.
