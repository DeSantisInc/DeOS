#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import configobj
import simplejson as json
import jsonschema
import web
import ruamel.yaml as yaml

def load_config(fname):
    config = configobj.ConfigObj(fname)
    return config

def read(fname):
    data = open(TEMPLATE_PATH+fname).read()
    data = data.replace('$','$$'
              ).replace('Δ with', '$def with'
              ).replace('Δ','$')
    return data

def write(fname, code):
    with open(fname, 'w') as f:
        f.write(code)

def render(fname):
    raw = read(fname)
    code = web.template.Template(raw)
    return code

def build(fname, data):
    code = render(fname)
    return str(code(data)).replace(8*' ','\t'
                         ).replace('$(False)', '$(FALSE)'
                         ).replace('$(True)', '$(TRUE)'
                         ).replace('\n\nifeq', '\nifeq'
                         ).replace('\n\nelse', '\nelse'
                         ).replace('\n\nendif', '\nendif'
                         )[1:]

def get_name(data, debug=False):
    res = None
    try:
        name = data.split('\n')[0]
        if name[0:3] == '# `' and name[-1] == '`':
            res = name[3:-1]
    except:
        name = None
    else:
        if debug:
            print(name)
    finally:
        return res

def load(fname):
    data, name, raw, schema = None, None, None, None
    with open(fname) as f:
        raw = f.read()
    if isinstance(raw, basestring):
        data = raw
        name = get_name(data)
        if isinstance(name, basestring):
            raw = raw.split('\n')[1:]
            if '## Environment' in raw:
                print('env: found')
            if '## Schema' in raw:
                print('schema: found')
            if '## Template' in raw:
                print('template: found')
    return data

def main():
    config = load_config('Deosfile')
    for key, value in config.iteritems():
        if key not in ('author', 'version') and 'type' in value:
            if value['type'] == 'make':
                data = load(value['meta'])

if __name__ == "__main__":
    main()
