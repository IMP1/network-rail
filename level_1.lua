local level = {}

level.world = "world_1.lua"

level.triggers = {

}

level.trains = {
    {
        position  = {14, 2},
        direction = 0,
        carriages = 3,
        route     = {
            {
                station = "LDS",
                time    = "00:00",
            },
            {
                station = "SHP",
                time    = "01:00",
            },
        },
    },
}

return level