ESX = nil
local shopItems = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

MySQL.ready(function()

	MySQL.Async.fetchAll('SELECT * FROM weashops', {}, function(result)
		for i=1, #result, 1 do
			if shopItems[result[i].zone] == nil then
				shopItems[result[i].zone] = {}
			end

			table.insert(shopItems[result[i].zone], {
				item  = result[i].item,
				price = result[i].price,
				label = ESX.GetWeaponLabel(result[i].item)
			})
		end

		TriggerClientEvent('esx_weaponshop:sendShop', -1, shopItems)
	end)

end)

ESX.RegisterServerCallback('esx_weaponshop:getShop', function(source, cb)
	cb(shopItems)
end)

ESX.RegisterServerCallback('esx_weaponshop:buyLicense', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
    
	if xPlayer.getAccount('bank').money >= Config.LicensePrice then --If player has bank money
		xPlayer.removeAccountMoney('bank', Config.LicensePrice)
		TriggerEvent('esx_license:addLicense', source, 'weapon', function()
			cb(true)
		end)
	elseif xPlayer.getMoney() >= Config.LicensePrice then --If no bank, but they have cash
        xPlayer.removeMoney(Config.LicensePrice)
        TriggerEvent('esx_license:addLicense', source, 'weapon', function()
        	cb(true) 
   		end)
    else --If no bank, and no cash
		xPlayer.showNotification(_U('not_enough'))
		cb(false)
	end
end)

ESX.RegisterServerCallback('esx_weaponshop:buyWeapon', function(source, cb, weaponName, zone)
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = GetPrice(weaponName, zone)
	local ped = GetPlayerPed(-1) -- Added via Kakarot

	if price == 0 then
		print(('esx_weaponshop: %s attempted to buy a unknown weapon!'):format(xPlayer.identifier))
		cb(false)
	else 
		if xPlayer.hasWeapon(weaponName) then
			if xPlayer.getAccount('bank').money >= price then --Check bank, can they afford ammo?
				xPlayer.removeAccountMoney('bank', price)
				xPlayer.removeWeapon(weaponName)
				print('esx_weaponshop: This weapon got removed!')		
				xPlayer.addWeapon(weaponName, 200) -- TODO: Tie this to a column in the DB that determines num of ammo
				cb(true)
			elseif xPlayer.getMoney() >= price then -- If they have cash for ammo
				xPlayer.removeMoney(price)
				cb(true)
			else 
				xPlayer.showNotification(_U('not_enough'))
				cb(false)
			end
		else -- If they don't have the weapon
			if zone == 'BlackWeashop' then
				if xPlayer.getAccount('black_money').money >= price then
					xPlayer.removeAccountMoney('black_money', price)
					xPlayer.addWeapon(weaponName, 42)
	
					cb(true)
				else
					xPlayer.showNotification(_U('not_enough_black'))
					cb(false)
				end
			else -- If they're at a legal weapon shop
				if xPlayer.getAccount('bank').money >= price then --Check bank, can they afford ammo?
					xPlayer.removeAccountMoney('bank', price)
					xPlayer.removeWeapon(weaponName)
					print('esx_weaponshop: This weapon got removed!')		
					xPlayer.addWeapon(weaponName, 42) -- TODO: Tie this to a column in the DB that determines num of ammo
					cb(true)
				elseif xPlayer.getMoney() >= price then -- If they have cash for ammo
					xPlayer.removeMoney(price)
					xPlayer.addWeapon(weaponName, 42)
					cb(true)
				else
					xPlayer.showNotification(_U('not_enough'))
					cb(false)
				end
			end 
		end 
	end 
end)

function GetPrice(weaponName, zone)
	local price = MySQL.Sync.fetchScalar('SELECT price FROM weashops WHERE zone = @zone AND item = @item', {
		['@zone'] = zone,
		['@item'] = weaponName
	})

	if price then
		return price
	else
		return 0
	end
end
