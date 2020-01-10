local world = {}

world.world_string = [[

     r__________l            r_____________l
    r____________l          /               \
___<______________>________<_________________>_______r_______l
                                                    /         \
                                                   (           )
                                                   |           |
                                                   [           ]
                                                    \         /
                                                     >_______<


]]

world.char_map = {
    ["_"] = "E_W",
    ["l"] = "W_SE",
    ["\\"] = "SE_NW",
    [")"] = "NW_S",
    ["|"] = "S_N",
    ["]"] = "N_SW",
    ["/"] = "SW_NE",
    ["<"] = "NE_W",
    -- ["_"] = "W_E", 
    [">"] = "E_NW",
    -- ["\\"] = "NW_SE",
    ["["] = "SE_N",
    -- ["|"] = "N_S",
    ["("] = "NE_S",
    -- ["/"] = "NE_SW",
    ["r"] = "E_SW",
}

world.switches = {
    {x = 4,  y = 4, options = {"NE_W", "E_W"}},
    {x = 5,  y = 3, options = {"NE_SW", "E_SW"}},
    {x = 18, y = 3, options = {"NW_SE", "W_SE"}},
    {x = 19, y = 4, options = {"NW_E", "W_E"}},

    {x = 28, y = 4, options = {"NE_W", "E_W"}},
    {x = 46, y = 4, options = {"NW_E", "W_E"}},

    {x = 54, y = 4, options = {"E_W", "E_SW"}},
}

world.signals = {
    {x = 22, y = 4, start_green = true},

    {x = 15, y = 2, start_green = false},
    {x = 16, y = 3, start_green = false},
    {x = 17, y = 4, start_green = true},

    {x = 42, y = 2, start_green = false},
    {x = 44, y = 4, start_green = true},

    {x = 52, y = 6, start_green = false},
}

world.stations = {
    {
        name = "Leeds",
        code = "LDS",
        platforms = {
            { 
                name = "1", 
                tracks = { {8,2},{9,2},{10,2},{11,2},{12,2},{13,2} },
                signal = 2,
            },
            { 
                name = "2", 
                tracks = { {7,3},{8,3},{9,3},{10,3},{11,3},{12,3},{13,3},{14,3} },
                signal = 3,
            },
        }
    },
    {
        name = "Shipley", 
        code = "SHP",
        platforms = {
            { 
                name = "1", 
                tracks = { {32,2},{33,2},{34,2},{35,2},{36,2},{37,2} },
                signal = 5,
            },
        }
    },
}

return world