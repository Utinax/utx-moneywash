ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('utx-moneywash:parakontrol', function(source, cb, gereklisayi)
	local xPlayer = ESX.GetPlayerFromId(source)
    local karapara = xPlayer.getAccount('black_money').money
	if karapara >= gereklisayi then
		cb(true)
	else
        activity = 0
        TriggerClientEvent('esx:showNotification', source, 'Üzerinde yeterli Kara Para yok!')
	end
end)

RegisterServerEvent('utx-moneywash:paraakla')
AddEventHandler('utx-moneywash:paraakla', function()
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    local karapara = xPlayer.getAccount('black_money').money
    if karapara >= Config.GerekliSayi then
        xPlayer.removeAccountMoney('black_money', karapara)
        Citizen.Wait(500)
        xPlayer.addMoney(karapara / Config.Bolum)
    end
end)