# ep_weave
import os
import tempfile

def _run_solr_proxy(port):
    conf = tempfile.NamedTemporaryFile(mode='w', delete=False)
    conf.write('''
LogLevel Warning
PidFile "/run/tinyproxy/tinyproxy.pid"
Logfile "/tmp/tinyproxy-solr.log"
MaxClients 5
MinSpareServers 5
MaxSpareServers 20
StartServers 10
Port {port}
ReverseOnly Yes
Upstream http localhost:8983
'''.format(port=port))
    conf.close()
    return ['tinyproxy', '-d', '-c', conf.name]

c.ServerProxy.servers = {
  'solr': {
    'command': _run_solr_proxy,
    'absolute_url': True,
    'timeout': 30,
  },
  'ep_weave': {
    'command': lambda port: ['/opt/nbtags/bin/run-ep-proxy.sh', f'{port}'],
    'absolute_url': False,
    'timeout': 30,
  }
}

# load additional config files
additional_config_path = os.environ.get('JUPYTER_ADDITIONAL_CONFIG_PATH',
                                        '/jupyter_notebook_config.d')
if os.path.exists(additional_config_path):
    for filename in sorted(os.listdir(additional_config_path)):
        _, ext = os.path.splitext(filename)
        if ext.lower() != '.py':
            continue
        load_subconfig(os.path.join(additional_config_path, filename))
