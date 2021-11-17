ENTITY_DEFS = {
    ['player'] = {
        width = 20,
        height = 18,
        mass = 30,
        linearImpulse = 5000,
        force = 12000,
        maxLinearVelocity = 300,
        animations = {
            ['walk-right'] = {
                frames = {1, 2, 3, 4},
                interval = 0.15,
                looping = true,
                texture = 'player'
            },
            ['walk-left'] = {
                frames = {5, 6, 7, 8},
                interval = 0.15,
                looping = true,
                texture = 'player'
            },
            ['idle-right'] = {
                frames = {1},
                looping = false,
                texture = 'player'
            },
            ['idle-left'] = {
                frames = {5},
                looping = false,
                texture = 'player'
            },
            ['jump-right'] = {
                frames = {9},
                looping = false,
                texture = 'player'
            },
            ['jump-left'] = {
                frames = {11},
                looping = false,
                texture = 'player'
            },
            ['hurt-right'] = {
                frames = {10},
                looping = false,
                texture = 'player'
            },
            ['hurt-left'] = {
                frames = {12},
                looping = false,
                texture = 'player'
            }
        }
    },
    ['coins'] = {
        width = 16,
        height = 16,
        animations = {
            ['not-picked-up'] = {
                frames = {1, 2, 3, 4},
                interval = 0.10,
                looping = true,
                texture = 'coins'
            },
            ['picked-up'] = {
                frames = {5, 6, 7, 8},
                interval = 0.10,
                looping = false,
                texture = 'coins'
            }
        }
    }
}