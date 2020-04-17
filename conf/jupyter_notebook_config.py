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

if 'NBSEARCHDB_HOSTNAME' in os.environ:
    c.NBSearchDB.hostname = os.environ['NBSEARCHDB_HOSTNAME']

if 'NBSEARCHDB_PORT' in os.environ:
    c.NBSearchDB.port = int(os.environ['NBSEARCHDB_PORT'])

if 'NBSEARCHDB_DATABASE' in os.environ:
    c.NBSearchDB.database = os.environ['NBSEARCHDB_DATABASE']
    del os.environ['NBSEARCHDB_DATABASE']

if 'NBSEARCHDB_COLLECTION' in os.environ:
    c.NBSearchDB.collection = os.environ['NBSEARCHDB_COLLECTION']
    del os.environ['NBSEARCHDB_COLLECTION']

if 'NBSEARCHDB_USERNAME' in os.environ:
    c.NBSearchDB.username = os.environ['NBSEARCHDB_USERNAME']
    del os.environ['NBSEARCHDB_USERNAME']

if 'NBSEARCHDB_PASSWORD' in os.environ:
    c.NBSearchDB.password = os.environ['NBSEARCHDB_PASSWORD']
    del os.environ['NBSEARCHDB_PASSWORD']

c.LocalSource.base_dir = os.environ['NBSEARCHDB_BASE_DIR'] \
                         if 'NBSEARCHDB_BASE_DIR' in os.environ else \
                         '/home/{}'.format(os.environ['NB_USER'])
