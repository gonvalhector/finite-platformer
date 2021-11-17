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
                texture = 'player'
            },
            ['walk-left'] = {
                frames = {5, 6, 7, 8},
                interval = 0.15,
                texture = 'player'
            },
            ['idle-right'] = {
                frames = {1},
                texture = 'player'
            },
            ['idle-left'] = {
                frames = {5},
                texture = 'player'
            },
            ['jump-right'] = {
                frames = {9},
                texture = 'player'
            },
            ['jump-left'] = {
                frames = {11},
                texture = 'player'
            },
            ['hurt-right'] = {
                frames = {10},
                texture = 'player'
            },
            ['hurt-left'] = {
                frames = {12},
                texture = 'player'
            }
        }
    }
}