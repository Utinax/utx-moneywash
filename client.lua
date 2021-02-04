ESX = nil

local yikiyormu = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(1)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

function DrawText3D(x, y, z, text)
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()
    local sleep = 2000
    while true do
        local ped = PlayerPedId()
        local pCoords = GetEntityCoords(ped)
        local distance = GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, Config.Koordinat.x, Config.Koordinat.y, Config.Koordinat.z, false)
        if Config.Emlak then
            if ESX.PlayerData.job.name == "realestateagent" then
                if distance < 5 then
                    sleep = 5
                    DrawText3D(Config.Koordinat.x, Config.Koordinat.y, Config.Koordinat.z, '[E] - Kara Para Akla')
                    if IsControlJustPressed(0, 38) then
                        ParaAkla()
                    end
                end
            end
        else
            if distance < 5 then
                sleep = 5
                DrawText3D(Config.Koordinat.x, Config.Koordinat.y, Config.Koordinat.z, '[E] - Kara Para Akla')
                if IsControlJustPressed(0, 38) then
                    ParaAkla()
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

function ParaAkla()
    if not yikiyormu then
        ESX.TriggerServerCallback('utx-moneywash:parakontrol', function(data)
            yikiyormu = true
            exports['mythic_progbar']:Progress({
                name = "karaparaaklama",
                duration = 10000,
                label = 'Kara para aklıyorsun...',
                useWhileDead = false,
                canCancel = false,
                controlDisables = {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                },
                animation = {
                    animDict = "mp_arresting",
                    anim = "a_uncuff",
                    flags = 49,
                },
            }, function(cancelled)
                if not cancelled then
                    TriggerServerEvent('utx-moneywash:paraakla')
                    yikiyormu = false
                    ESX.ShowNotification('Başarıyla kara para akladın!')
                else
                    -- Do Something If Action Was Cancelled
                end
            end)
        end, Config.GerekliSayi)
    end
end
