---Config with all global variables
cfg = {
    commandName = 'emotePanel', -- Open the animations panel
    commandSuggestion = 'Open the emote panel', -- Open the animations panel suggestion
    commandNameEmote = 'e', -- Play an animation by command
    commandNameSuggestion = 'Play an animation by command', -- Play an animation by command suggestion
    keyActive = false, -- Use key for opening the panel
    keyLetter = 'F5', -- Which key for opening the panel if cfg.keyActive is true
    keySuggestion = 'Open the emote panel by key', -- Suggestion on keybind mapping
    walkingTransition = 0.5,

    acceptKey = 38,
    denyKey = 182,

    -- Do not touch
    useTnotify = GetResourceState('t-notify') == 'started',
    panelStatus = false,

    animActive = false,
    animDuration = 1500, -- You can change this but I recommend not to.
    animLoop = false,
    animMovement = false,

    sceneActive = false,

    propActive = false,
    propsEntities = {},

    ptfxActive = false,
    ptfxEntities = {},

    malePeds = {
        "mp_m_freemode_01"
    },

    sharedActive = false,

    cancelKey = 73, -- Default key for cancelling an animation. Users can change this manually too.
    defaultCommand = 'fav', -- Emote command execution
    defaultEmote = 'dance', -- Default emote by default
    defaultEmoteUseKey = true, -- Don't recommend setting this to false unless you change UI
    defaultEmoteKey = 20 -- Default emote command key
}