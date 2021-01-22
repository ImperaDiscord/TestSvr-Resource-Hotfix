ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_clotheshop:saveOutfit')
AddEventHandler('esx_clotheshop:saveOutfit', function(label, skin)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		local dressing = store.get('dressing')

		if dressing == nil then
			dressing = {}
		end

		table.insert(dressing, {
			label = label,
			skin  = skin
		})

		store.set('dressing', dressing)
		store.save()
	end)
end)

ESX.RegisterServerCallback('esx_clotheshop:buyClothes', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)


	if xPlayer.getAccount('bank').money >= Config.Price then --If player has bank money
		xPlayer.removeAccountMoney('bank', Config.Price)
		TriggerClientEvent('esx:showNotification', source, _U('you_paid', Config.Price))
		cb(true)
		end)
	else if xPlayer.getMoney() >= Config.Price then --If no bank, but they have cash
			xPlayer.removeMoney(Config.Price)
			TriggerClientEvent('esx:showNotification', source, _U('you_paid', Config.Price))
			cb(true)
	else --If no bank, and no cash
		xPlayer.showNotification(_U('not_enough'))
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_clotheshop:checkPropertyDataStore', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local foundStore = false

	TriggerEvent('esx_datastore:getDataStore', 'property', xPlayer.identifier, function(store)
		foundStore = true
	end)

	cb(foundStore)
end)