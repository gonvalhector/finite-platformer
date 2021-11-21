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
            },
            ['death-right'] = {
                frames = {13},
                looping = false,
                texture = 'player'
            },
            ['death-left'] = {
                frames = {14},
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
    },
    ['pumpkinhead'] = {
        width = 16,
        height = 16,
        mass = 20,
        linearImpulse = 50,
        animations = {
            ['walk-left'] = {
                frames = {1, 2, 3},
                interval = 0.15,
                looping = true,
                texture = 'enemies-a'
            },
            ['walk-right'] = {
                frames = {5, 6, 7},
                interval = 0.15,
                looping = true,
                texture = 'enemies-a'
            },
            ['hurt-left'] = {
                frames = {4},
                looping = false,
                texture = 'enemies-a'
            },
            ['hurt-right'] = {
                frames = {8},
                looping = false,
                texture = 'enemies-a'
            },
        }
    },
    ['slimeball'] = {
        width = 16,
        height = 16,
        mass = 15,
        linearImpulse = 50,
        animations = {
            ['walk-left'] = {
                frames = {9, 10},
                interval = 0.15,
                looping = true,
                texture = 'enemies-a'
            },
            ['walk-right'] = {
                frames = {13, 14},
                interval = 0.15,
                looping = true,
                texture = 'enemies-a'
            },
            ['hurt-left'] = {
                frames = {11},
                looping = false,
                texture = 'enemies-a'
            },
            ['hurt-right'] = {
                frames = {15},
                looping = false,
                texture = 'enemies-a'
            },
        }
    },
    ['beetlejuice'] = {
        width = 16,
        height = 16,
        mass = 15,
        linearImpulse = 50,
        animations = {
            ['walk-left'] = {
                frames = {17, 18},
                interval = 0.15,
                looping = true,
                texture = 'enemies-a'
            },
            ['walk-right'] = {
                frames = {21, 22},
                interval = 0.15,
                looping = true,
                texture = 'enemies-a'
            },
            ['hurt-left'] = {
                frames = {19},
                looping = false,
                texture = 'enemies-a'
            },
            ['hurt-right'] = {
                frames = {23},
                looping = false,
                texture = 'enemies-a'
            },
        }
    },
}