local dict = 'core'
local particle = 'ent_amb_fbi_smoke_linger_hvy'
local soundName = 'ALARMS_KLAXON_03_CLOSE'
local soundBank = '0'  -- No specific sound bank needed

RegisterNetEvent('qb-smokescreen:deploy', function(coords)
    print("client side triggered - qbsc")

    -- Load and play the alarm sound
    RequestScriptAudioBank("DLC_WMSIRENS\\SIRENPOLICE", false)
    while not HasSoundFinished(-1) do
        Citizen.Wait(0)
    end
    local alarmSound = PlaySoundFromCoord(-1, soundName, coords.x, coords.y, coords.z, 0, 0, 0)
    Citizen.Wait(5000)  -- Wait for 5 seconds

    -- Request the particle dictionary.
    RequestNamedPtfxAsset(dict)
    -- Wait for the particle dictionary to load.
    while not HasNamedPtfxAssetLoaded(dict) do
        Citizen.Wait(0)
    end

    print("spawning smoke effect")

    -- Define the initial radius and expansion parameters
    local radius = 1.0
    local maxRadius = 20.0  -- Maximum radius for the smoke effect
    local expansionRate = 1.0  -- Rate at which the smoke expands
    local time = 45000  -- Total time for smoke effect in milliseconds
    local startTime = GetGameTimer()

    while GetGameTimer() - startTime < time do
        local angle = 0
        while angle < 360 do
            local offsetX = math.cos(math.rad(angle)) * radius
            local offsetY = math.sin(math.rad(angle)) * radius
            UseParticleFxAssetNextCall(dict)
            StartParticleFxLoopedAtCoord(particle, coords.x + offsetX, coords.y + offsetY, coords.z, 0.0, 0.0, 0.0, 1.0, false, false, false, false)
            angle = angle + 30  -- Increase angle increment to reduce number of particles
        end
        radius = radius + expansionRate
        if radius > maxRadius then radius = maxRadius end
        Citizen.Wait(1000)  -- Wait for 1 second before expanding the smoke further
    end

    -- Optional: Clear all particles after the effect
    RemoveParticleFxInRange(coords.x, coords.y, coords.z, maxRadius)
    StopSound(alarmSound)
end)
