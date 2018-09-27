# To install, execute the following command
#    ipython profile create
# Copy this file to .ipython/profile_default/startup
from IPython import get_ipython

save_get_ipython_system = get_ipython().system
get_ipython().system = lambda x: get_ipython_system(x)

# interactiveshell.py's system_piped() function comment saids:
# "we store the exit_code in user_ns."
# this function check the exit_code and raise exception if it is not 0.
def get_ipython_system(_cmd):
    save_get_ipython_system(_cmd)
    if get_ipython().user_ns['_exit_code'] != 0:
        raise RuntimeError('Unexpected exit code: %d' % get_ipython().user_ns['_exit_code'])
