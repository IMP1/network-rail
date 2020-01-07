local pallete = {}
    
pallete.BLACK = {0, 0, 0}
pallete.WHITE = {1, 1, 1}

pallete.STOP = {0.7, 0, 0}
pallete.WARN = {0.7, 0.5, 0}
pallete.GO   = {0, 0.7, 0}

pallete.SELECTABLE = {1, 1, 1, 0.5}
pallete.SELECTION  = {0, 1, 0.5, 1}

pallete.LATE    = pallete.STOP
pallete.MISSED  = pallete.WARN
pallete.ON_TIME = pallete.BLACK

pallete.CANCELLED = pallete.STOP
pallete.DELAYED   = pallete.WARN

return pallete