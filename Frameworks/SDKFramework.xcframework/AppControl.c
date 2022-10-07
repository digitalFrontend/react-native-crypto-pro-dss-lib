//
//  AppControl.c
//  AppABC
//
//  Created by Ivan Yakovenko on 06.09.2022.
//
#include <stdint.h>
#define HASH_GR3411_SIZE 32

typedef struct
{
    uint32_t size;
    uint8_t checksum[HASH_GR3411_SIZE];
} check_info;


check_info program_control_sum __attribute__ ((used))
                 __attribute__ ((__visibility__("default")))
                 __attribute__ ((section ("__DATA, __const")));
