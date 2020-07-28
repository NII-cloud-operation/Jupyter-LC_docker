import re
import sys
import os

def replace_file(src_path, dst_path, host_ip_list):
    with open(src_path, 'r') as src_file:
        with open(dst_path, 'w') as dst_file:
            for line in src_file:
                for host, (name, ip_addr, private_ip) in host_ip_list.items():
                    line = re.sub('{' + host + '}', '{} ansible_ssh_host={}'.format(name, ip_addr), line)
                dst_file.write(line)
