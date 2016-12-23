# `src/hello.py`

## Schema

```yaml
type: object
required: [a, b, c]
properties:
  a: {type: number}
  b: {type: number}
  c: {type: number}
```

## Environment

```yaml
a: 1
b: 2
c: 3
```

## Template

```python
Δ with (data=None)
#!/usr/bin/env python
# -*- coding: utf-8 -*-

from __future__ import print_function

def main():
    print('hello, world!')

if __name__=="__main__":
    main()
```

## Test: Environment

```yaml
a: 1
b: 2
c: 3
```

## Test: Pass

```sh
#!/bin/sh
echo "1"
echo "2"
echo "3"
```

## Test: Fail

```sh
#!/bin/sh
echo "3"
echo "2"
echo "1"
```
