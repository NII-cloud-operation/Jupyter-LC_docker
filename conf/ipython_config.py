import glob
import sys
import os.path

c.InteractiveShellApp.exec_files = glob.glob(os.path.join(sys.prefix, 'etc', 'ipython', '[0-9][0-9]*.py'))

