---Config with all global variables
cfg = {
    commandName = 'emotePanel',
    commandSuggestion = 'Open the emote panel',
    keyActive = false,
    keyLetter = 'F5',
    keySuggestion = 'Open the emote panel by key',
    cancelKey = 38,

    -- Do not touch
    useTnotify = GetResourceState('t-notify') == 'started' or false,
    panelStatus = false,

    animActive = false,
    animDuration = 1500, -- You can change this but I recommend not to.
    animLoop = false,
    animMovement = false,

    sceneActive = false,
    sceneForcedEnd = false,

    propActive = false,
    propsEntities = {},

    ptfxActive = false,
    ptfxEntities = {},

    malePeds = {
        "mp_m_freemode_01"
    }
}