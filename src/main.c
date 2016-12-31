#include <Python.h>
#include <stdio.h>
#include <stdlib.h>

int
main(int argc, char const *argv[])
{   Py_Initialize();
    #define X(python)\
    PyRun_SimpleString(python);
    #include "deos.def"
    Py_Finalize();
    return EXIT_SUCCESS;
}
