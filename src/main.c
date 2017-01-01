#include <Python.h>
#include "atdlib.h"

int
main(int argc, char const *argv[])
{   deArray(double) *a1;
    a1 = newArray(double);
    printf("%d\n",a1->size);
    freeArray(double, a1);
    return EXIT_SUCCESS;
}
