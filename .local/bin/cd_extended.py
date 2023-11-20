#!/usr/bin/env python3

import sys
import re

def usage():
    print(\
"""Usage: cd_extended [operation]*
    operations:
    - assign: [idx]=dirname
        change i'th directory element into <dirname>, accepts negative index
    - substitute: ^pat^val
        substitute <pat> into <val> globaly (like bash's history modification syntax)
    - default: path
        sets the whole path with <path>
Example:
    ~/wezterm/window/src/ $ cd_extended [-2]=wezterm-client
    ~/wezterm/wezterm-client/src/ $ cd_extended ^wezterm^putty
    ~/putty/putty-client/src/ $ echo 'very good!'""", file=sys.stderr)

def path_assign(path, dst, val):
    dst = int(dst)
    val = re.sub(r'\[(-?\d+)\]', lambda m: path[int(m[0])], val)
    path = path.copy()
    path[dst] = val
    return path

def path_subst(path, pat, new):
    return [ p.replace(pat, new) for p in path ]

try:
    if '-h' in sys.argv or '--help' in sys.argv:
        usage()
        exit(1) # non-zero exit for not printing modified path

    pwd = sys.argv[1]

    path = pwd.split('/')

    for arg in sys.argv[2:]:
        #m = re.match(r'\[((-?\d+)|(-?\d+)?:(-?\d+)?)\]=(.*)', arg)
        if m := re.match(r'\[(-?\d+)\]=(.*)', arg):
            path = path_assign(path, m[1], m[2])
        elif m := re.match(r'\^([^^]+)\^([^^]+)', arg):
            path = path_subst(path, m[1], m[2])
        else:
            path = [arg]

        m = re.match(r'\[(-?\d+)\]=(.*)', arg)

    print('/'.join(path))

except Exception as e:
    usage()
    raise e # python interpreter aborts this program
    # non-zero exit for not printing modified path
