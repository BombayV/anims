---Load table functions
Load = {}

Load.Dict = function(dict)
    repeat
        RequestAnimDict(dict)
        Wait(50)
    until HasAnimDictLoaded(dict)
    local awaitRemoval = promise.new()
end

Load.Model = function(model)
    local hashModel = GetHashKey(model)
    while not HasModelLoaded(hashModel) do
        RequestModel(hashModel)
        Wait(50)
    end
end

Load.Ptfx = function(asset)
    while not HasNamedPtfxAssetLoaded(asset) do
        RequestNamedPtfxAsset(asset)
        Wait(50)
    end
    UseParticleFxAssetNextCall(asset)
end