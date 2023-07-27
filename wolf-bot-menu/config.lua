Config = {}

-------------------------------------- MENUS --------------------------------------------
Config.TeleportMenu = false
Config.modeMenu = true
Config.modesMenu = true
Config.modessMenu = true
Config.VehicleSpawnMenu = false
Config.WeaponMenu = false
------------------------------------- OPTIONS -------------------------------------------
Config.Suicide = false
-------------------------------------------------------------------------------------------------- 
Config.Vehicles = {
    [1] = {
         name = "Bus",
         id = "bus"
     },	
     [2] = {
        name = "Delete",
        id = "bus"
    },		
 }

Config.locations = {
    [1] = {
        coords = vector3(-278.27,-1630.33,31.85),
        heading = 169.82,
        name = "MS | Weed",
	    },
    [2] = {
        coords = vector3(-1019.19,-2977.57,13.95),
        heading = 235.66,
        name = "MS | Airport",
    },
    [3] = {
        coords = vector3(2043.82,2788.98,50.03),
        heading = 189.45,
        name = "MS | Arena",
    },
    [4] = {
        coords = vector3(1436.06,1111.15,114.19),
        heading = 272.15,
        name = "MS | Ranch",
	},	
	[5] = {
		coords = vector3 (213.73,-2548.52,5.88),
		heading = 102.26,
		name = "~r~MS | Train Tracks",
    },
   
}

Config.teleports = {
    [1] = {
        coords = vector3(-278.27,-1630.33,31.85),
        heading = 169.82,
        name = "MS | Weed",
	    },
    [2] = {
        coords = vector3(-1019.19,-2977.57,13.95),
        heading = 235.66,
        name = "MS | Airport",
    },
    [3] = {
        coords = vector3(2043.82,2788.98,50.03),
        heading = 189.45,
        name = "MS | Arena",
    },
    [4] = {
        coords = vector3(1436.06,1111.15,114.19),
        heading = 272.15,
        name = "MS | Ranch",
	},	
	[5] = {
		coords = vector3 (213.73,-2548.52,5.88),
		heading = 102.26,
		name = "~r~MS | Train Tracks",
    },
   
}

Config.mode = {
    [1] = {
        coords = vector3(-278.27,-1630.33,31.85),
        heading = 169.82,
        name = "Join Death Match",
	    },
    [2] = {
        coords = vector3(-1019.19,-2977.57,13.95),
        heading = 235.66,
        name = "Exit Death Match",
    }, 
    [3] = {
        coords = vector3(-1019.19,-2977.57,13.95),
        heading = 235.66,
        name = "Death Match ScoreBoard",
    }, 
}

Config.modes = {
    [1] = {
        coords = vector3(-278.27,-1630.33,31.85),
        heading = 169.82,
        name = "Join Demoltion Derby",
	    },
    [2] = {
        coords = vector3(-1019.19,-2977.57,13.95),
        heading = 235.66,
        name = "/minigame leave to exit",
    }, 
}

Config.modess = {
    [1] = {
        coords = vector3(-278.27,-1630.33,31.85),
        heading = 169.82,
        name = "Ground Attack (10 M)",
	    },
    [2] = {
        coords = vector3(-1019.19,-2977.57,13.95),
        heading = 235.66,
        name = "Ground Attack (20 M)",
    }, 
    [3] = {
        coords = vector3(-1019.19,-2977.57,13.95),
        heading = 235.66,
        name = "Ground Attack (30 M)",
    },
    [3] = {
        coords = vector3(-1019.19,-2977.57,13.95),
        heading = 235.66,
        name = "Ground Attack (50 M)",
    },  
    [4] = {
        coords = vector3(-1019.19,-2977.57,13.95),
        heading = 235.66,
        name = "Ground Attack (100 M)",
    },  
    [5] = {
        coords = vector3(-1019.19,-2977.57,13.95),
        heading = 235.66,
        name = "Ground Attack (200 M)",
    }, 
    [6] = {
        coords = vector3(-1019.19,-2977.57,13.95),
        heading = 235.66,
        name = "Ground Attack (300 M)",
    }, 
}

Config.OnPlayerFocus = {
    enabled = false, -- Play sound when cam is on player
    data = {"CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET"}
}
Config.OnPlayerFocuse = {
    enabled = false, -- Play sound when cam is on player
    data = {"RACE_PLACED", "HUD_AWARDS"}
}