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
                time    = "07:00",
            },
            {
                station = "SHP",
                time    = "08:00",
            },
        },
    },
}

level.start_time = "00:00"

return level