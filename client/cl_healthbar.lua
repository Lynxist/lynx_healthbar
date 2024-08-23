QBCore = exports['qb-core']:GetCoreObject()

local previousEntity = nil

function Round(value, numDecimalPlaces)
    if numDecimalPlaces then
        local power = 10^numDecimalPlaces
        return math.floor((value * power) + 0.5) / (power)
    else
        return math.floor(value + 0.5)
    end
end

function getEntityScreenCoordsUsingCenter(entity)
    local entityCenter = GetEntityCoords(entity)
    local screenX, screenY = GetActiveScreenResolution()
    local onScreen, x, y = GetScreenCoordFromWorldCoord(entityCenter.x, entityCenter.y, entityCenter.z + 1.0, screenX, screenY)
    
    if onScreen then
        x = math.floor(x * screenX)
        y = math.floor(y * screenY)
        return x, y
    end
    return nil, nil
end

function updateHealthBarOnClient(entity, currentHealth, maxHealth, x, y)
    SendNUIMessage({
        type = "updateHealthBar",
        entityId = entity,
        currentHealth = currentHealth,
        maxHealth = maxHealth,
        x = x,
        y = y
    })
end

function hideHealthBarOnClient(entity)
    SendNUIMessage({
        type = "hideHealthBar",
        entityId = entity
    })
end

CreateThread(function()
    while true do
        local bool, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
        
        if bool and IsEntityAPed(entity) and not IsPedAPlayer(entity) and not IsPedDeadOrDying(entity) then
            local health = GetEntityHealth(entity) - 100
            local coords = GetEntityCoords(entity)
            local maxHealth = GetPedMaxHealth(entity) - 100
            local percentage = Round((health / maxHealth) * 100)
            
            local x, y = getEntityScreenCoordsUsingCenter(entity)
            if x and y then
                updateHealthBarOnClient(entity, health, maxHealth, x, y)
            end
            
            previousEntity = entity
        else
            if previousEntity then
                hideHealthBarOnClient(previousEntity)
                previousEntity = nil
            end
            Wait(100)
        end
        Wait(15)
    end
end)