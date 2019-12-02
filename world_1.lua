local world = {}

world.world_string = [[
     j__________l            j_____________l
    j____________l          /               \
___<______________>________<_________________>________
]]

world.char_map = {
    ["_"] = "E_W",
    ["<"] = "NE_W",
    [">"] = "NW_E",
    ["j"] = "E_SW",
    ["l"] = "W_SE",
    ["/"] = "SW_NE",
    ["\\"] = "NW_SE",
}

world.switches = {
    {x = 4,  y = 3, options = {"NE_W", "E_W"}},
    {x = 5,  y = 2, options = {"NE_SW", "E_SW"}},
    {x = 18, y = 2, options = {"NW_SE", "W_SE"}},
    {x = 19, y = 3, options = {"NW_E", "W_E"}},
}

world.signals = {
    {x = 22, y = 3, start = false}
}

world.stations = {
    {
        name = "Leeds",
        platforms = {
            { 
                name = "1", 
                tracks = { {8,1},{9,1},{10,1},{11,1},{12,1},{13,1} },
            },
        }
    },
    {
        name = "Shipley", 
        platforms = {
            { 
                name = "1", 
                tracks = { {32,1},{33,1},{34,1},{35,1},{36,1},{37,1} },
            },
        }
    },
}

return world