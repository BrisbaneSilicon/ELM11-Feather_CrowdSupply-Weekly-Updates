#define LUA_LIB

#include "lprefix.h"

#include <limits.h>
#include <stddef.h>
#include <string.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"


// 'Bit-Bash' user Driver-Layer program

#define MAX_BITBASH_SHIFT_COUNT     (32)
                                    
#define BITBASH_CLOCK_PIN           (3)
#define BITBASH_DATA_PIN            (4)


/* ------------------ Users Lua API ----------------------  */

    // NOTE: User to add any custom API
    // functions here.

    // NOTE: Ensure that all API functions are
    // included in the 'User API Registry' below,
    // in order for them to be callable from the
    // Lua appliction layer.


/*
** The 'Bit-Bash' of Driver Layer extension.
*/
static int luaU_bitbash (lua_State *L) {
    unsigned int shift_val;
    unsigned int shift_count;
    int n;

    n = lua_gettop(L);
    if (n != 2) {
        // NOTE: verify two arguments have
        // been passed to the function.

        luaL_error(L, "unexpected argument");
    }
    
    // REVISIT: this function assumes that the I/O
    // are configured correctly...

    shift_val = (unsigned int)luaL_checkinteger(L, 1);
        // NOTE: fetch and check first argument (value
        // to shift) is an integer    
    shift_count = (unsigned int)luaL_checkinteger(L, 2);
        // NOTE: fetch and check second argument (number
        // of bits to shift) is an integer
        
    if(shift_count > MAX_BITBASH_SHIFT_COUNT){
        luaL_error(L, "Max bitbash shift count (%d) exceeded!", MAX_BITBASH_SHIFT_COUNT);
    }
    
    for(; shift_count > 0; shift_count--) {
        set_gpio(BITBASH_CLOCK_PIN, 0);
        set_gpio(BITBASH_DATA_PIN, (shift_val & 1));
        set_gpio(BITBASH_CLOCK_PIN, 1);
        
        shift_val >>= 1;
    }
    
    set_gpio(BITBASH_CLOCK_PIN, 0);
    set_gpio(BITBASH_DATA_PIN, 0);

    return 0;
        // NOTE: no results were pushed onto the
        // the Lua stack.
}


/* ------------------ User API Registry ----------------------------  */

static const luaL_Reg user_api_registry[] = {
    // NOTE: ensure you add any new custom API
    // functions to this array in order to ensure
    // they can be imported from the Lua Interpreter.

    {"bitbash", luaU_bitbash},

    {NULL, NULL}
};



/* ------------------ Boilerplate Library Code ----------------------  */

static const luaL_Reg userlib_default[] = {
    {NULL, NULL}
};

/*
** Open user library
*/
LUAMOD_API int luaopen_user (lua_State *L) {
    luaL_newlib(L, userlib_default);
    return 1;
}

LUAMOD_API int luaimportfunc_user (lua_State *L, const char *fname) {
    uint32_t i;

    i = 0;
    while(1) {
        if (!user_api_registry[i].name) {
            return 1;
        }

        if (strcmp(fname, user_api_registry[i].name) == 0) {
            lua_getglobal(L, LUA_USERLIBNAME);
            luaL_setfunc(L, &user_api_registry[i], 0);

            break;
        }

        i++;
    }

    return 0;
}