#define LUA_LIB

#include "lprefix.h"

#include <limits.h>
#include <stddef.h>
#include <string.h>

#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"


// Skeleton user Driver-Layer program


/* ------------------ Users Lua API ----------------------  */

    // NOTE: User to add any custom API
    // functions here.

    // NOTE: Ensure that all API functions are
    // included in the 'User API Registry' below,
    // in order for them to be callable from the
    // Lua appliction layer.


/*
** The 'Hello World' of Driver Layer extensions.
*/
static int luaU_helloworld (lua_State *L) {

    lua_pushstring(L, "Hello World!");
        // NOTE: push a constant string onto the
        // the Lua stack.

    return 1;
        // NOTE: one result was pushed onto the
        // the Lua stack.
}


/* ------------------ User API Registry ----------------------------  */

static const luaL_Reg user_api_registry[] = {
    // NOTE: ensure you add any new custom API
    // functions to this array in order to ensure
    // they can be imported from the Lua Interpreter.

    {"helloworld", luaU_helloworld},

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