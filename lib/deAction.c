#include "deAction.h"

#ifdef __cplusplus
extern "C" {
#endif

deAction *
newAction(int id)
{   deAction *ptr = malloc(sizeof(deAction));
    if (ptr == NULL) return NULL;
    memset(ptr, 0, sizeof(deAction));
    ptr->id = id;
    return ptr;
}

#ifdef __cplusplus
}
#endif
