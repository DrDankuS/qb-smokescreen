local QBCore = exports['qb-core']:GetCoreObject()

RegisterNetEvent('qb-smokescreen:server:deploySmokescreen')
AddEventHandler('qb-smokescreen:server:deploySmokescreen', function()
    local src = source
    print("Deploying smokescreen for player ID: " .. src)

    local playerPed = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(playerPed)
    
    -- Get the player's heading
    local heading = GetEntityHeading(playerPed)

    -- Calculate the forward vector based on the heading
    local forwardVector = vector3(
        math.cos(math.rad(heading)),
        math.sin(math.rad(heading)),
        0
    )

    -- Calculate the position 2 meters forward and 1 meter up
    local deployCoords = playerCoords + forwardVector * 2.0 + vector3(0, 0, 1.0)

    print("Smokescreen deployed at coordinates: " .. deployCoords.x .. ", " .. deployCoords.y .. ", " .. deployCoords.z)

    -- Trigger the client event to deploy the smokescreen
    TriggerClientEvent('qb-smokescreen:deploy', -1, deployCoords)
end)