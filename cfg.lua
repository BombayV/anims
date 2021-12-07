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
    animActiveType = nil or 'dance',
    animDuration = 1000,
    animLoop = false,
    animUpperBody = false,
    animMovement = false,

    sceneActive = false,

    propActive = false,
    propsEntities = {},

    malePeds = {
        "mp_m_freemode_01"
    }
}