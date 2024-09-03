local inSafeZone = false

Citizen.CreateThread(function()
    for _, zone in ipairs(Config.SafeZones) do
        local blip = AddBlipForRadius(zone.coords, zone.radius)
        SetBlipColour(blip, zone.blipColor)
        SetBlipAlpha(blip, 100)
        SetBlipAsShortRange(blip, true)
    end

    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        inSafeZone = false

        for _, zone in ipairs(Config.SafeZones) do
            local distance = #(playerCoords - zone.coords)

            if distance <= zone.radius then
                inSafeZone = true
                DisableControlAction(0, 24, true) 
                DisableControlAction(0, 69, true) 
                DisableControlAction(0, 92, true) 
                DisableControlAction(0, 114, true) 
                DisableControlAction(0, 140, true) 
                DisableControlAction(0, 257, true) 
                DisableControlAction(0, 263, true) 
                DisableControlAction(0, 264, true) 
                DisablePlayerFiring(playerPed, true) 
                SetEntityInvincible(playerPed, true) 
                SetEntityProofs(playerPed, true, true, true, true, true, true, true, true)
                SetEntityCanBeDamaged(playerPed, false)

                SetPedCanRagdoll(playerPed, false)
                break
            end
        end

        if not inSafeZone then
            SetEntityInvincible(playerPed, false)
            SetEntityProofs(playerPed, false, false, false, false, false, false, false, false)
            SetEntityCanBeDamaged(playerPed, true)

            SetPedCanRagdoll(playerPed, true)
        end

        for _, zone in ipairs(Config.SafeZones) do
            local color = zone.markerColor
            DrawMarker(
                1,
                zone.coords.x,
                zone.coords.y,
                zone.coords.z - 1.0,
                0.0, 0.0, 0.0,
                0.0, 0.0, 0.0,
                zone.radius * 2.0,
                zone.radius * 2.0,
                5.0,
                color.r, color.g, color.b,
                color.a,
                false, true, 2, 
                false, false, false, false
            )
        end

        Citizen.Wait(0)
    end
end)
