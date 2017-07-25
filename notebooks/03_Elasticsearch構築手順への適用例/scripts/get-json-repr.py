def get_block_device_mappings_repr(o):
    return ','.join(map(lambda kv: '{}={}'.format(kv[0],
                                                  '{' + get_block_device_mappings_repr(kv[1]) + '}' if kv[0] == 'Ebs' else kv[1]),
                        o.items()))