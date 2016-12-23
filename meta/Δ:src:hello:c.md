# `src/hello.c`

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

```c
Δ with (data=None)

#include <stdio.h>
#include <stdlib.h>

int
main(int argc, char const *argv[])
{   printf("hello, world!\n");
    return EXIT_SUCCESS;
}
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
