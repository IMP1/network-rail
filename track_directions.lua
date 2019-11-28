local directions = {
    E_W = { -- east to west
        [0] = 0,
        [4] = 4,
    },
    SE_W = { -- south-east to west
        [0] = 1,
        [5] = 4,
    },
    NE_W = { -- north-east to west
        [0] = 7,
        [3] = 4,
    },

    SE_NW = { -- south-east to north-west
        [1] = 1,
        [5] = 5,
    },
    E_NW = { -- east to north-west
        [1] = 0,
        [4] = 5,
    },
    S_NW = { -- south to north-west
        [1] = 2,
        [6] = 5,
    },

    S_N = { -- south to north
        [2] = 2,
        [6] = 6,
    },
    SE_N = { -- south-east to north
        [2] = 1,
        [5] = 6,
    },
    SW_N = { -- south-west to north
        [2] = 3,
        [7] = 6,
    },

    SW_NE = { -- south-west to north-east
        [3] = 3,
        [7] = 7,
    },
    S_NE = { -- south to north-east
        [3] = 2,
        [6] = 6,
    },
    W_NE = { -- west to north-east
        [3] = 4,
        [0] = 7,
    },

    W_E = { -- west to east
        [0] = 0,
        [4] = 4,
    },
    SW_E = { -- south-west to east
        [7] = 0,
        [4] = 2,
    },
    NW_E = { -- north-west to east
        [1] = 0,
        [4] = 5,
    },

    NW_SE = { -- north-west to south-east
        [1] = 1,
        [5] = 5,
    },
    W_SE = { -- west to south-east
        [0] = 1,
        [5] = 4,
    },
    N_SE = { -- north to south-east
        [2] = 1,
        [5] = 6,
    },

    N_S = { -- north to south
        [2] = 2,
        [6] = 6,
    },
    NW_S = { -- north-west to south
        [1] = 2,
        [6] = 5,
    },
    NE_S = { -- north-east to south
        [3] = 2,
        [6] = 7,
    },

    NE_SW = { -- north-east to south-west
        [3] = 3,
        [7] = 7,
    },
    N_SW = { -- north to south-west
        [2] = 3,
        [7] = 6,
    },
    E_SW = { -- east to south-west
        [4] = 3,
        [7] = 0,
    },
}


return directions
