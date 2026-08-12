--[[
        Demonstrate 'Hello World' driver function
--]]

program_name = "Hello World Driver Demonstration"


-- Program dependencies

import('msleep')

import('user', 'helloworld')


-- Program configuration



-- Main program begin

print("\n -------- Program begin: "..program_name.." --------\n")
msleep(500)

ret = user.helloworld()
if ret == "Hello World!" then
    print("Driver Layer working as expected!")
else
    print("Driver Layer not working as expected - user function 'helloworld' returned: "..ret)
end

-- Main program end

print("\n -------- Program end: "..program_name.." --------\n")