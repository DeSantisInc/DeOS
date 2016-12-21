#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import configobj
import simplejson as json
import jsonschema
import web
import ruamel.yaml as yaml

TEMPLATE_PATH = "src/template"

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

def load():
    data, schema = None, None
    with open('Deosfile') as f:
        raw = f.read().split('---')
    if isinstance(raw, list):
        if isinstance(raw[1], basestring):
            data = yaml.safe_load(raw[2])
        if isinstance(raw[0], basestring):
            schema = yaml.safe_load(raw[1])
    if isinstance(data, dict) and isinstance(schema, dict):
        jsonschema.validate(data, schema)
        print(json.dumps(data, sort_keys=True, indent=2))
    else:
        return None
    return data

def main():
    #data = load()
    #if isinstance(data, dict):
    #    code = build('deosrc.tao.mk', data['.deosrc'])
    #    write('var/build/.deosrc', code)
    #    code = build('makefile.tao.mk', data['Makefile'])
    #    write('var/build/Makefile', code)
    config = load_config('Deosfile')
    for key, value in config.iteritems():
        if key not in ('author', 'version') and 'type' in value:
            if value['type'] == 'make':
                template_file = "%s/%s.tao.mk" % (TEMPLATE_PATH, key)
                print(template_file)

if __name__ == "__main__":
    main()
