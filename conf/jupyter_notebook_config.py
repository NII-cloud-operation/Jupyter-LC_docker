import os
c.NotebookApp.ip = '*'
c.NotebookApp.allow_remote_access = True
c.MultiKernelManager.kernel_manager_class = 'lc_wrapper.AsyncLCWrapperKernelManager'
c.KernelManager.shutdown_wait_time = 10.0
c.FileContentsManager.delete_to_trash = False
c.NotebookApp.quit_button = False
c.NotebookApp.kernel_spec_manager_class = 'lc_wrapper.LCWrapperKernelSpecManager'

c.LabApp.custom_css = True

# Enable the JupyterLab extension for nbsearch magic commands
c.JupyterNotebookApp.expose_app_in_browser = True
c.LabApp.expose_app_in_browser = True

if 'PASSWORD' in os.environ:
    from notebook.auth import passwd
    c.NotebookApp.password = passwd(os.environ['PASSWORD'])
    del os.environ['PASSWORD']

if 'SIDESTICKIES_SCRAPBOX_COOKIE_CONNECT_SID' in os.environ and os.environ['SIDESTICKIES_SCRAPBOX_COOKIE_CONNECT_SID']:
    c.ScrapboxAPI.cookie_connect_sid = os.environ['SIDESTICKIES_SCRAPBOX_'
                                                  'COOKIE_CONNECT_SID']
    del os.environ['SIDESTICKIES_SCRAPBOX_COOKIE_CONNECT_SID']

if 'SIDESTICKIES_SCRAPBOX_PROJECT_ID' in os.environ and os.environ['SIDESTICKIES_SCRAPBOX_PROJECT_ID']:
    c.ScrapboxAPI.project_id = os.environ['SIDESTICKIES_SCRAPBOX_PROJECT_ID']

if 'SIDESTICKIES_EP_WEAVE_URL' in os.environ and os.environ['SIDESTICKIES_EP_WEAVE_URL']:
    # Enables EpWeaveAPI
    c.SidestickiesAPI.api_class = "nbtags.api.EpWeaveAPI"
    c.EpWeaveAPI.url = os.environ['SIDESTICKIES_EP_WEAVE_URL']

if 'SIDESTICKIES_EP_WEAVE_API_KEY' in os.environ and os.environ['SIDESTICKIES_EP_WEAVE_API_KEY']:
    c.EpWeaveAPI.apikey = os.environ['SIDESTICKIES_EP_WEAVE_API_KEY']
    del os.environ['SIDESTICKIES_EP_WEAVE_API_KEY']

if 'SIDESTICKIES_EP_WEAVE_API_URL' in os.environ and os.environ['SIDESTICKIES_EP_WEAVE_API_URL']:
    c.EpWeaveAPI.api_url = os.environ['SIDESTICKIES_EP_WEAVE_API_URL']

if 'NBSEARCHDB_SOLR_BASE_URL' in os.environ and os.environ['NBSEARCHDB_SOLR_BASE_URL']:
    c.NBSearchDB.solr_base_url = os.environ['NBSEARCHDB_SOLR_BASE_URL']

if 'NBSEARCHDB_S3_ENDPOINT_URL' in os.environ and os.environ['NBSEARCHDB_S3_ENDPOINT_URL']:
    c.NBSearchDB.s3_endpoint_url = os.environ['NBSEARCHDB_S3_ENDPOINT_URL']

if 'NBSEARCHDB_SOLR_BASIC_AUTH_USERNAME' in os.environ and os.environ['NBSEARCHDB_SOLR_BASIC_AUTH_USERNAME']:
    c.NBSearchDB.solr_basic_auth_username = os.environ['NBSEARCHDB_SOLR_BASIC_AUTH_USERNAME']
    del os.environ['NBSEARCHDB_SOLR_BASIC_AUTH_USERNAME']

if 'NBSEARCHDB_SOLR_BASIC_AUTH_PASSWORD' in os.environ and os.environ['NBSEARCHDB_SOLR_BASIC_AUTH_PASSWORD']:
    c.NBSearchDB.solr_basic_auth_password = os.environ['NBSEARCHDB_SOLR_BASIC_AUTH_PASSWORD']
    del os.environ['NBSEARCHDB_SOLR_BASIC_AUTH_PASSWORD']

if 'NBSEARCHDB_SOLR_NOTEBOOK' in os.environ and os.environ['NBSEARCHDB_SOLR_NOTEBOOK']:
    c.NBSearchDB.solr_notebook = os.environ['NBSEARCHDB_SOLR_NOTEBOOK']
    del os.environ['NBSEARCHDB_SOLR_NOTEBOOK']

if 'NBSEARCHDB_SOLR_CELL' in os.environ and os.environ['NBSEARCHDB_SOLR_CELL']:
    c.NBSearchDB.solr_cell = os.environ['NBSEARCHDB_SOLR_CELL']
    del os.environ['NBSEARCHDB_SOLR_CELL']

if 'NBSEARCHDB_S3_ACCESS_KEY' in os.environ and os.environ['NBSEARCHDB_S3_ACCESS_KEY']:
    c.NBSearchDB.s3_access_key = os.environ['NBSEARCHDB_S3_ACCESS_KEY']
    del os.environ['NBSEARCHDB_S3_ACCESS_KEY']

if 'NBSEARCHDB_S3_SECRET_KEY' in os.environ and os.environ['NBSEARCHDB_S3_SECRET_KEY']:
    c.NBSearchDB.s3_secret_key = os.environ['NBSEARCHDB_S3_SECRET_KEY']
    del os.environ['NBSEARCHDB_S3_SECRET_KEY']

if 'NBSEARCHDB_S3_REGION_NAME' in os.environ and os.environ['NBSEARCHDB_S3_REGION_NAME']:
    c.NBSearchDB.s3_region_name = os.environ['NBSEARCHDB_S3_REGION_NAME']
    del os.environ['NBSEARCHDB_S3_REGION_NAME']

if 'NBSEARCHDB_S3_BUCKET_NAME' in os.environ and os.environ['NBSEARCHDB_S3_BUCKET_NAME']:
    c.NBSearchDB.s3_bucket_name = os.environ['NBSEARCHDB_S3_BUCKET_NAME']
    del os.environ['NBSEARCHDB_S3_BUCKET_NAME']

c.LocalSource.base_dir = os.environ['NBSEARCHDB_BASE_DIR'] \
                         if 'NBSEARCHDB_BASE_DIR' in os.environ else \
                         '/home/{}'.format(os.environ['NB_USER'])

c.LocalSource.server = os.environ['NBSEARCHDB_MY_SERVER_URL'] \
                       if 'NBSEARCHDB_MY_SERVER_URL' in os.environ else \
                       'http://localhost:8888/'

# The configuration of the nbwhisper extension
# https://github.com/NII-cloud-operation/nbwhisper/tree/feature/lab?tab=readme-ov-file#options
# singlaing_url: The URL of the signaling server
if 'NBWHISPER_SIGNALING_URL' in os.environ and os.environ['NBWHISPER_SIGNALING_URL']:
    c.NBWhisper.signaling_url = os.environ['NBWHISPER_SIGNALING_URL']

# api_key: The API key for the signaling server
if 'NBWHISPER_SORA_API_KEY' in os.environ and os.environ['NBWHISPER_SORA_API_KEY']:
    c.NBWhisper.api_key = os.environ['NBWHISPER_SORA_API_KEY']
    # Secrets removed from environment variables
    del os.environ['NBWHISPER_SORA_API_KEY']

# channel_id_prefix: The prefix of the channel ID using the WebRTC SFU
if 'NBWHISPER_CHANNEL_ID_PREFIX' in os.environ and os.environ['NBWHISPER_CHANNEL_ID_PREFIX']:
    c.NBWhisper.channel_id_prefix = os.environ['NBWHISPER_CHANNEL_ID_PREFIX']
    del os.environ['NBWHISPER_CHANNEL_ID_PREFIX']

# channel_id_suffix: The suffix of the channel ID using the WebRTC SFU
if 'NBWHISPER_CHANNEL_ID_SUFFIX' in os.environ and os.environ['NBWHISPER_CHANNEL_ID_SUFFIX']:
    c.NBWhisper.channel_id_suffix = os.environ['NBWHISPER_CHANNEL_ID_SUFFIX']
    del os.environ['NBWHISPER_CHANNEL_ID_SUFFIX']

# share_current_tab_only: If true, only the current tab is shared
# Users can set True, Yes, Y or 1 to enable this feature
if 'NBWHISPER_SHARE_CURRENT_TAB_ONLY' in os.environ and os.environ['NBWHISPER_SHARE_CURRENT_TAB_ONLY']:
    share_current_tab_only = os.environ['NBWHISPER_SHARE_CURRENT_TAB_ONLY']
    if share_current_tab_only.lower() in ['true', 'yes', 'y', '1']:
        c.NBWhisper.share_current_tab_only = True
    else:
        c.NBWhisper.share_current_tab_only = False

# Deprecated: (Legacy) SkyWay API is not used for now
if 'NBWHISPER_SKYWAY_API_TOKEN' in os.environ and os.environ['NBWHISPER_SKYWAY_API_TOKEN']:
    c.NBWhisper.skyway_api_token = os.environ['NBWHISPER_SKYWAY_API_TOKEN']
    # Secrets removed from environment variables
    del os.environ['NBWHISPER_SKYWAY_API_TOKEN']

if 'NBWHISPER_ROOM_MODE_FOR_WAITING_ROOM' in os.environ and os.environ['NBWHISPER_ROOM_MODE_FOR_WAITING_ROOM']:
    c.NBWhisper.room_mode_for_waiting_room = os.environ['NBWHISPER_ROOM_MODE_FOR_WAITING_ROOM']

if 'NBWHISPER_ROOM_MODE_FOR_TALKING_ROOM' in os.environ and os.environ['NBWHISPER_ROOM_MODE_FOR_TALKING_ROOM']:
    c.NBWhisper.room_mode_for_talking_room = os.environ['NBWHISPER_ROOM_MODE_FOR_TALKING_ROOM']
