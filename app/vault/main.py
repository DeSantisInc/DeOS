#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

import configobj
import jsonschema
import web

import simplejson as json
import ruamel.yaml as yaml

TEMPLATES=['add_password_dialog']

def _partial(filename, env=None):
    code,res=None,None
    try:
        if isinstance(filename,basestring):
            with open('./templates/partials/'+filename+'.xml') as f:
                raw=str(f.read())
                code=web.template.Template(raw)
                if isinstance(code,web.template.Template):
                    res=str(code(env))
                else:
                    print('not instance!')
    except:
        print('render_partial: filename:%s env=%s'%(filename,env))
    else:
        if isinstance(res, basestring):
            with open('./build/partials/'+filename+'.ui','w') as f:
                f.write(res)
    finally:
        return res

def partial(name, env=None):
    render=web.template.render('./templates/partials/')
    if 'item'==name:
        res=str(render.item(env=env))
        res='\n'.join([12*' '+x for x in res.split('\n')[0:-1]])[10:]
        return res
    return '</error func=partial>'

def render():
    for template in TEMPLATES:
        with open('templates/'+template+'.xml') as f:
            code=web.template.render('./templates/')
            code._add_global(partial,'render')
            with open('config/'+template+'.yml') as y:
                data=y.read()
                if isinstance(data, basestring):
                    env=yaml.safe_load(data)
                    with open('build/'+template+'.ui','w') as p:
                        res=str(code.add_password_dialog(env))
                        p.write(res)

def main():
    render()

if __name__=="__main__":
    main()
