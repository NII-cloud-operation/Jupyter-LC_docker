import os
c.NotebookApp.ip = '*'
c.NotebookApp.allow_remote_access = True
c.MultiKernelManager.kernel_manager_class = 'lc_wrapper.LCWrapperKernelManager'
c.KernelManager.shutdown_wait_time = 10.0
c.FileContentsManager.delete_to_trash = False
c.NotebookApp.quit_button = False
c.NotebookApp.kernel_spec_manager_class = 'lc_wrapper.LCWrapperKernelSpecManager'

if 'PASSWORD' in os.environ:
    from notebook.auth import passwd
    c.NotebookApp.password = passwd(os.environ['PASSWORD'])
    del os.environ['PASSWORD']

if 'SIDESTICKIES_SCRAPBOX_COOKIE_CONNECT_SID' in os.environ:
    c.ScrapboxAPI.cookie_connect_sid = os.environ['SIDESTICKIES_SCRAPBOX_'
                                                  'COOKIE_CONNECT_SID']
    del os.environ['SIDESTICKIES_SCRAPBOX_COOKIE_CONNECT_SID']

if 'SIDESTICKIES_SCRAPBOX_PROJECT_ID' in os.environ:
    c.ScrapboxAPI.project_id = os.environ['SIDESTICKIES_SCRAPBOX_PROJECT_ID']

if 'NBSEARCHDB_SOLR_BASE_URL' in os.environ:
    c.NBSearchDB.solr_base_url = os.environ['NBSEARCHDB_SOLR_BASE_URL']

if 'NBSEARCHDB_S3_ENDPOINT_URL' in os.environ:
    c.NBSearchDB.s3_endpoint_url = os.environ['NBSEARCHDB_S3_ENDPOINT_URL']

if 'NBSEARCHDB_SOLR_BASIC_AUTH_USERNAME' in os.environ:
    c.NBSearchDB.solr_basic_auth_username = os.environ['NBSEARCHDB_SOLR_BASIC_AUTH_USERNAME']
    del os.environ['NBSEARCHDB_SOLR_BASIC_AUTH_USERNAME']

if 'NBSEARCHDB_SOLR_BASIC_AUTH_PASSWORD' in os.environ:
    c.NBSearchDB.solr_basic_auth_password = os.environ['NBSEARCHDB_SOLR_BASIC_AUTH_PASSWORD']
    del os.environ['NBSEARCHDB_SOLR_BASIC_AUTH_PASSWORD']

if 'NBSEARCHDB_SOLR_NOTEBOOK' in os.environ:
    c.NBSearchDB.solr_notebook = os.environ['NBSEARCHDB_SOLR_NOTEBOOK']
    del os.environ['NBSEARCHDB_SOLR_NOTEBOOK']

if 'NBSEARCHDB_SOLR_CELL' in os.environ:
    c.NBSearchDB.solr_cell = os.environ['NBSEARCHDB_SOLR_CELL']
    del os.environ['NBSEARCHDB_SOLR_CELL']

if 'NBSEARCHDB_S3_ACCESS_KEY' in os.environ:
    c.NBSearchDB.s3_access_key = os.environ['NBSEARCHDB_S3_ACCESS_KEY']
    del os.environ['NBSEARCHDB_S3_ACCESS_KEY']

if 'NBSEARCHDB_S3_SECRET_KEY' in os.environ:
    c.NBSearchDB.s3_secret_key = os.environ['NBSEARCHDB_S3_SECRET_KEY']
    del os.environ['NBSEARCHDB_S3_SECRET_KEY']

if 'NBSEARCHDB_S3_REGION_NAME' in os.environ:
    c.NBSearchDB.s3_region_name = os.environ['NBSEARCHDB_S3_REGION_NAME']
    del os.environ['NBSEARCHDB_S3_REGION_NAME']

if 'NBSEARCHDB_S3_BUCKET_NAME' in os.environ:
    c.NBSearchDB.s3_bucket_name = os.environ['NBSEARCHDB_S3_BUCKET_NAME']
    del os.environ['NBSEARCHDB_S3_BUCKET_NAME']

c.LocalSource.base_dir = os.environ['NBSEARCHDB_BASE_DIR'] \
                         if 'NBSEARCHDB_BASE_DIR' in os.environ else \
                         '/home/{}'.format(os.environ['NB_USER'])

c.LocalSource.server = os.environ['NBSEARCHDB_MY_SERVER_URL'] \
                       if 'NBSEARCHDB_MY_SERVER_URL' in os.environ else \
                       'http://localhost:8888/'

if 'NBWHISPER_SKYWAY_API_TOKEN' in os.environ:
    c.NBWhisper.skyway_api_token = os.environ['NBWHISPER_SKYWAY_API_TOKEN']
    # Secrets removed from environment variables
    del os.environ['NBWHISPER_SKYWAY_API_TOKEN']

if 'NBWHISPER_ROOM_MODE_FOR_WAITING_ROOM' in os.environ:
    c.NBWhisper.room_mode_for_waiting_room = os.environ['NBWHISPER_ROOM_MODE_FOR_WAITING_ROOM']

if 'NBWHISPER_ROOM_MODE_FOR_TALKING_ROOM' in os.environ:
    c.NBWhisper.room_mode_for_talking_room = os.environ['NBWHISPER_ROOM_MODE_FOR_TALKING_ROOM']