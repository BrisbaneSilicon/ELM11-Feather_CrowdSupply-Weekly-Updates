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