local world_string = [[
      ____________
    ⋌_____________⋋
___⋌_______________⋋___
]]

local char_map = {
    ["_"] = "E_W",
    ["⋌"] = "NE_W",
    ["⋋"] = "NW_E",
}

local switches = {
    {x = 4,  y = 3, options = {"NE_W", "E_W"}},
    {x = 5,  y = 2, options = {"NE_SW", "E_SW"}},
    {x = 19, y = 2, options = {"NW_SE", "W_SE"}},
    {x = 20, y = 3, options = {"NW_E", "W_E"}},
}

local signals = {

}

local stations = {
    {
        name = "Leeds", 
        platforms = {
            { 
                name = "1", 
                tracks = { {8,1},{9,1},{10,1},{11,1},{12,1},{13,1} },
            },
        }
    }
}