//#include "het_lib.h"

#define _GNU_SOURCE
#include <sched.h>
#include <stdio.h>
#include <errno.h>

int current_variant = 0; // cache current variant to avoid syscalls
int variant_A = 0;

// TODO adapt do different hosts
const int variant_per_core[] = {1, 1, 0, 0}; // this is for bs

static inline int get_preferred_variant() {
    unsigned int core;
    getcpu(&core, NULL);
    return variant_per_core[core];
}

static inline void het_ensure_variant(int variant){ // only 0 and 1 allowed
    current_variant = variant;
}

void het_ensure_A(){
#ifndef N_ENABLE
    het_ensure_variant(0);
#endif /* N_ENABLE */
}

void het_ensure_B(){
#ifndef N_ENABLE
    het_ensure_variant(1);
#endif /* N_ENABLE */
}

void check_and_switch(){
#ifndef N_ENABLE
    het_ensure_variant(get_preferred_variant());
#endif /* N_ENABLE */
}
