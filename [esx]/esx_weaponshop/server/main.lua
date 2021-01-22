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
	else if xPlayer.getMoney() >= Config.LicensePrice then --If no bank, but they have cash
        xPlayer.removeMoney(Config.LicensePrice)
        TriggerEvent('esx_license:addLicense', source, 'weapon', function()
        cb(true)
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
			print("pre vars")
			local playerPed  = GetPlayerPed(-1)
			local weaponList = ESX.GetWeaponList()
			local a = xPlayer.inventory
			print(a)
			
			xPlayer.removeWeapon(weaponName)
			print('esx_weaponshop: This weapon got removed!')
			xPlayer.addWeapon(weaponName, 200) -- TODO: Tie this to a column in the DB that determines num of ammo
			--ADD_AMMO_TO_PED(playerPed, weaponName, 300) --Added from Kakarot
			--GiveWeaponToPed(xPlayer, weaponName, 100, false, false) -- Gonna try this next
			--AddAmmoToPed(xPlayer, GetWeaponLabel(weaponName), 100)
			print(('esx_weaponshop: And then %s did!! addWeapon and removing the weapon was used'):format(xPlayer.identifier))
			--xPlayer.addWeapon(weaponName, 50)
			--xPlayer.showNotification(_U('already_owned'))
			cb(true)
		else
			if zone == 'BlackWeashop' then
				if xPlayer.getAccount('black_money').money >= price then
					xPlayer.removeAccountMoney('black_money', price)
					xPlayer.addWeapon(weaponName, 42)
	
					cb(true)
				else
					xPlayer.showNotification(_U('not_enough_black'))
					cb(false)
				end
			else -- Player doesn't own the gun, let's buy the gun
				if xPlayer.getAccount('bank').money >=  price then -- Check bank
					xPlayer.removeAccountMoney('bank', price)
					xPlayer.addWeapon(weaponName, 42)
	
					cb(true)
				else if  xPlayer.getMoney() >= price then -- If they have that cash tho
					xPlayer.removeMoney(price)
					xPlayer.addWeapon(weaponName, 42)
				else -- Broke-ass
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
