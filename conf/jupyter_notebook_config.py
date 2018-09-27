import os
c.NotebookApp.ip = '*'
c.NotebookApp.allow_remote_access = True
c.MultiKernelManager.kernel_manager_class = 'lc_wrapper.LCWrapperKernelManager'
c.KernelManager.shutdown_wait_time = 10.0
c.FileContentsManager.delete_to_trash = False
c.NotebookApp.quit_button = False

if 'PASSWORD' in os.environ:
    from notebook.auth import passwd
    c.NotebookApp.password = passwd(os.environ['PASSWORD'])
    del os.environ['PASSWORD']
