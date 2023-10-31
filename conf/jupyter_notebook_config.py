import os

def is_env_var_defined(varname):
    return len(os.environ.get(varname, '')) > 0

c.NotebookApp.ip = '*'
c.NotebookApp.allow_remote_access = True
c.MultiKernelManager.kernel_manager_class = 'lc_wrapper.AsyncLCWrapperKernelManager'
c.KernelManager.shutdown_wait_time = 10.0
c.FileContentsManager.delete_to_trash = False
c.NotebookApp.quit_button = False
c.NotebookApp.kernel_spec_manager_class = 'lc_wrapper.LCWrapperKernelSpecManager'

if is_env_var_defined('PASSWORD'):
    from notebook.auth import passwd
    c.NotebookApp.password = passwd(os.environ['PASSWORD'])
    del os.environ['PASSWORD']

if is_env_var_defined('SIDESTICKIES_SCRAPBOX_COOKIE_CONNECT_SID'):
    c.ScrapboxAPI.cookie_connect_sid = os.environ['SIDESTICKIES_SCRAPBOX_'
                                                  'COOKIE_CONNECT_SID']
    del os.environ['SIDESTICKIES_SCRAPBOX_COOKIE_CONNECT_SID']

if is_env_var_defined('SIDESTICKIES_SCRAPBOX_PROJECT_ID'):
    c.ScrapboxAPI.project_id = os.environ['SIDESTICKIES_SCRAPBOX_PROJECT_ID']

if is_env_var_defined('SIDESTICKIES_EP_WEAVE_URL'):
    # Enables EpWeaveAPI
    c.SidestickiesAPI.api_class = "nbtags.api.EpWeaveAPI"
    c.EpWeaveAPI.url = os.environ['SIDESTICKIES_EP_WEAVE_URL']

if is_env_var_defined('SIDESTICKIES_EP_WEAVE_API_KEY'):
    c.EpWeaveAPI.apikey = os.environ['SIDESTICKIES_EP_WEAVE_API_KEY']
    del os.environ['SIDESTICKIES_EP_WEAVE_API_KEY']

if is_env_var_defined('SIDESTICKIES_EP_WEAVE_API_URL'):
    c.EpWeaveAPI.api_url = os.environ['SIDESTICKIES_EP_WEAVE_API_URL']

if is_env_var_defined('NBSEARCHDB_SOLR_BASE_URL'):
    c.NBSearchDB.solr_base_url = os.environ['NBSEARCHDB_SOLR_BASE_URL']

if is_env_var_defined('NBSEARCHDB_S3_ENDPOINT_URL'):
    c.NBSearchDB.s3_endpoint_url = os.environ['NBSEARCHDB_S3_ENDPOINT_URL']

if is_env_var_defined('NBSEARCHDB_SOLR_BASIC_AUTH_USERNAME'):
    c.NBSearchDB.solr_basic_auth_username = os.environ['NBSEARCHDB_SOLR_BASIC_AUTH_USERNAME']
    del os.environ['NBSEARCHDB_SOLR_BASIC_AUTH_USERNAME']

if is_env_var_defined('NBSEARCHDB_SOLR_BASIC_AUTH_PASSWORD'):
    c.NBSearchDB.solr_basic_auth_password = os.environ['NBSEARCHDB_SOLR_BASIC_AUTH_PASSWORD']
    del os.environ['NBSEARCHDB_SOLR_BASIC_AUTH_PASSWORD']

if is_env_var_defined('NBSEARCHDB_SOLR_NOTEBOOK'):
    c.NBSearchDB.solr_notebook = os.environ['NBSEARCHDB_SOLR_NOTEBOOK']
    del os.environ['NBSEARCHDB_SOLR_NOTEBOOK']

if is_env_var_defined('NBSEARCHDB_SOLR_CELL'):
    c.NBSearchDB.solr_cell = os.environ['NBSEARCHDB_SOLR_CELL']
    del os.environ['NBSEARCHDB_SOLR_CELL']

if is_env_var_defined('NBSEARCHDB_S3_ACCESS_KEY'):
    c.NBSearchDB.s3_access_key = os.environ['NBSEARCHDB_S3_ACCESS_KEY']
    del os.environ['NBSEARCHDB_S3_ACCESS_KEY']

if is_env_var_defined('NBSEARCHDB_S3_SECRET_KEY'):
    c.NBSearchDB.s3_secret_key = os.environ['NBSEARCHDB_S3_SECRET_KEY']
    del os.environ['NBSEARCHDB_S3_SECRET_KEY']

if is_env_var_defined('NBSEARCHDB_S3_REGION_NAME'):
    c.NBSearchDB.s3_region_name = os.environ['NBSEARCHDB_S3_REGION_NAME']
    del os.environ['NBSEARCHDB_S3_REGION_NAME']

if is_env_var_defined('NBSEARCHDB_S3_BUCKET_NAME'):
    c.NBSearchDB.s3_bucket_name = os.environ['NBSEARCHDB_S3_BUCKET_NAME']
    del os.environ['NBSEARCHDB_S3_BUCKET_NAME']

c.LocalSource.base_dir = os.environ['NBSEARCHDB_BASE_DIR'] \
                         if is_env_var_defined('NBSEARCHDB_BASE_DIR') else \
                         '/home/{}'.format(os.environ['NB_USER'])

c.LocalSource.server = os.environ['NBSEARCHDB_MY_SERVER_URL'] \
                       if is_env_var_defined('NBSEARCHDB_MY_SERVER_URL') else \
                       'http://localhost:8888/'

# owner field for updating solr index: NBSEARCHDB_OWNER (primary) -> JUPYTERHUB_USER -> NB_USER
if is_env_var_defined('NBSEARCHDB_OWNER'):
    c.LocalSource.owner = os.environ['NBSEARCHDB_OWNER']
elif is_env_var_defined('JUPYTERHUB_USER'):
    c.LocalSource.owner = os.environ['JUPYTERHUB_USER']
elif is_env_var_defined('NB_USER'):
    c.LocalSource.owner = os.environ['NB_USER']

if is_env_var_defined('NBWHISPER_SKYWAY_API_TOKEN'):
    c.NBWhisper.skyway_api_token = os.environ['NBWHISPER_SKYWAY_API_TOKEN']
    # Secrets removed from environment variables
    del os.environ['NBWHISPER_SKYWAY_API_TOKEN']

if is_env_var_defined('NBWHISPER_ROOM_MODE_FOR_WAITING_ROOM'):
    c.NBWhisper.room_mode_for_waiting_room = os.environ['NBWHISPER_ROOM_MODE_FOR_WAITING_ROOM']

if is_env_var_defined('NBWHISPER_ROOM_MODE_FOR_TALKING_ROOM'):
    c.NBWhisper.room_mode_for_talking_room = os.environ['NBWHISPER_ROOM_MODE_FOR_TALKING_ROOM']