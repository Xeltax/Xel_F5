ESX = nil
Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end

	RefreshMoney()

	RefreshMoney2()
end)

local societymoney, societymoney2, disable, admin, Checked, rang, color = nil, nil, true, true, false, "", "" --variable autre argent société, activer/désactiver, rang du joueur, couleur du text etc.
local DoorIndex = 1; -- variable pour la liste des portes de voiture
local DoorList = {"Avant Gauche", "Avant Droit", "Arrière Gauche", "Arrière Droit", "Capot", "Coffre"} -- variable pour les portes de voiture
local avantg, avantd, arriereg, arriered, capot, coffre = false, false, false, false, false, false -- variable pour les portes de voiture
local CardIndex = 1;
local CardList = {"Donner", "Regarder"} -- variable pour les cartes d'identité

local noclip, showCoords, godmode, ghostmode, showName, gamerTags = false, false, false, false, false, {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
	ESX.PlayerLoaded = true
end)

RegisterNetEvent('esx:onPlayerLogout')
AddEventHandler('esx:onPlayerLogout', function()
	ESX.PlayerLoaded = false
	ESX.PlayerData = {}
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job

	RefreshMoney()
end)

RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	ESX.PlayerData.job2 = job2

	RefreshMoney2()
end)

function OpenF5Menu()
	local MainMenu = RageUI.CreateMenu("Xel_F5", "Menu IntÉractions", 1, 1, "commonmenu", "gradient_bgd", 255, --[[Rouge]] 255, --[[Vert]] 0, --[[Bleu]] 0)
	MainMenu.EnableMouse = false;

	local Perso = RageUI.CreateSubMenu(MainMenu, "Citoyenneté", "IntÉractions  Personnelles")

	local Divers = RageUI.CreateSubMenu(MainMenu, "Citoyenneté", "IntÉractions  Diverses")

	local Info = RageUI.CreateSubMenu(MainMenu, "Informations", "Tous savoir sur le serveur")

	local SubMenu = RageUI.CreateSubMenu(Perso, "Portefeuille", "Portefeuille")

	local CashSubmenu = RageUI.CreateSubMenu(SubMenu, "Argent Cash", "Portefeuille")

	local DirtyCashSubmenu = RageUI.CreateSubMenu(SubMenu, "Argent Sale", "Portefeuille")

	local Vetement = RageUI.CreateSubMenu(Perso, "Vêtements", "Enlever/Mettre vos VÊtements")

	local Accessoires = RageUI.CreateSubMenu(Perso, "Accessoires", "Accessoires")

	local Societe = RageUI.CreateSubMenu(Divers, "Société", "Gestion SociÉtÉ")

	local Orga = RageUI.CreateSubMenu(Divers, "Organisation", "Gestion Organisation")

	local Vehicule = RageUI.CreateSubMenu(Divers, "Véhicule", "Gestion Véhicule")

	local Admin = RageUI.CreateSubMenu(MainMenu, "Administration", "Administration")

	local AdminJoueur = RageUI.CreateSubMenu(Admin, "Administration", "Joueurs")

	local AdminTP = RageUI.CreateSubMenu(Admin, "Administration", "TÉLÉPORTATION")

	local AdminSanction = RageUI.CreateSubMenu(Admin, "Administration", "Sacntion")
	
	local AdminVehicule = RageUI.CreateSubMenu(Admin, "Administration", "Véhicule")

	local SubMenu11 = RageUI.CreateSubMenu(MainMenu, "Vide", "Vide")

	function RageUI.PoolMenus:Example()
		MainMenu:IsVisible(function(Items)

			Items:AddSeparator("~b~↓~s~ Citoyenneté ~b~↓")

			Items:AddButton("📌\tIntéraction Personnelle", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)

			end, Perso)

			Items:AddButton("💡\tIntéraction Diverse", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)

			end, Divers)

			Items:AddButton("📜\tInformations", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)

			end, Info)

			Items:AddButton("⚜️\tAdministration", nil, { IsDisabled = admin, RightLabel = "~m~→→" }, function(onSelected)

			end, Admin)

		end, function(Panels)
		end)

		Perso:IsVisible(function(Items)
			-- Items

			Items:AddButton("💵 Portefeuille", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)

			end, SubMenu)

			Items:AddButton("👔 Vêtements", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
		
			end, Vetement)

			Items:AddButton("🧢 Accessoires", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
		
			end, Accessoires)

			Items:AddButton("🧾 Factures", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					ExecuteCommand('factures')

					CreateThread(function ()
						RageUI.CloseAll()
					end)
				end
			end)

		end, function()
			-- Panels
		end)

		Divers:IsVisible(function(Items)

			-- Items

			if ESX.PlayerData.job.grade_name == 'boss' then
				Items:AddButton("🏢\tGestion Société", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
			
				end, Societe)
			end

			if ESX.PlayerData.job2.grade_name == 'boss' then
				Items:AddButton("🏗\tGestion Organisation", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
			
				end, Orga)
			end
			
			if IsPedSittingInAnyVehicle(PlayerPedId()) then
				if (GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId(), false), -1) == PlayerPedId()) then
					disable = false
				end
			end

			Items:AddButton("🚘\tGestion Véhicule", nil, { IsDisabled = disable, RightLabel = "~m~→→" }, function(onSelected)
		
			end, Vehicule)

		end, function()
			-- Panels
		end)

		Info:IsVisible(function(Items)
			-- Items

			Items:AddSeparator("	Développer ~r~→~s~ ~p~Xeltax_~s~	")
			Items:AddSeparator("	Discord ~r~→~s~ ~b~BLABLABLA~s~	")
			

			Items:AddButton("💻\tTouches du serveur", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
		
			end, touche)

		end, function()
			-- Panels
		end)

		SubMenu:IsVisible(function(Items)
			-- Items
			Items:AddSeparator("↓ ~b~Informations~s~ ↓")

			Items:AddSeparator("~y~Job :~s~ " .. ESX.PlayerData.job.label .. "~y~ | ~s~" .. ESX.PlayerData.job.grade_label.. " ~y~|")

			Items:AddSeparator("~r~Gang :~s~ " .. ESX.PlayerData.job2.label .. "~r~ | ~s~" .. ESX.PlayerData.job2.grade_label .. " ~r~|")

			Items:AddSeparator("" .. GetPlayerName(PlayerId()) .." ~p~votre ID est :~s~ " ..GetPlayerServerId(PlayerId()))

			Items:AddSeparator("↓ ~g~Finance~s~ ↓")

			for i = 1, #ESX.PlayerData.accounts, 1 do
				if ESX.PlayerData.accounts[i].name == 'money' then
					Items:AddButton( "Argent Cash : ~g~" .. ESX.Math.GroupDigits(ESX.PlayerData.accounts[i].money) .. " ~s~$", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)

					end, CashSubmenu)
				end

				if ESX.PlayerData.accounts[i].name == 'bank' then
					Items:AddButton( "Banque : ~g~" .. ESX.PlayerData.accounts[i].money .. " ~s~$", nil, { IsDisabled = false }, function(onSelected)

					end)
				end

				if ESX.PlayerData.accounts[i].name == 'black_money' then
					Items:AddButton( "Argent Sale : ~r~" .. ESX.PlayerData.accounts[i].money .. " ~s~$", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)

					end, DirtyCashSubmenu)
				end
			end
			
			if Config.EnableJsFourIdCard == true then

				Items:AddList("Carte d'identité", CardList, CardIndex, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
					if (onListChange) then
						CardIndex = Index;
					end

					if (onSelected) then

						if Index == 1 then 

							closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		
							if closestDistance ~= -1 and closestDistance <= 3.0 then
								TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer))
							else
								ESX.ShowNotification("~r~Aucun joueur à proximité")
							end

						elseif Index == 2 then
							TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()))
						end
				
					end
					
				end)

				Items:AddList("Permis de conduire", CardList, CardIndex, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
					if (onListChange) then
						CardIndex = Index;
					end

					if (onSelected) then

						if Index == 1 then 

							closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		
							if closestDistance ~= -1 and closestDistance <= 3.0 then
								TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'driver')
							else
								ESX.ShowNotification("~r~Aucun joueur à proximité")
							end

						elseif Index == 2 then
							TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'driver')
						end
				
					end
					
				end)

				Items:AddList("Permis de port d'arme", CardList, CardIndex, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
					if (onListChange) then
						CardIndex = Index;
					end

					if (onSelected) then

						if Index == 1 then 

							closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
		
							if closestDistance ~= -1 and closestDistance <= 3.0 then
								TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(closestPlayer), 'weapon')
							else
								ESX.ShowNotification("~r~Aucun joueur à proximité")
							end

						elseif Index == 2 then
							TriggerServerEvent('jsfour-idcard:open', GetPlayerServerId(PlayerId()), GetPlayerServerId(PlayerId()), 'weapon')
						end
				
					end
					
				end)
				
			end


		end, function()
			-- Panels
		end)

		CashSubmenu:IsVisible(function(Items)
			Items:AddButton( "Donner", nil, { IsDisabled = false}, function(onSelected)
				if (onSelected) then

					local joueurProche = false

					closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	
					if closestDistance ~= -1 and closestDistance <= 3 then
	
						joueurProche = true
	
					end

					local quantity = KeyboardInput("Montant à jeter :", "", 20)
					local post = true

					if quantity ~= nil then
		
						quantity = tonumber(quantity)

						if type(quantity) == 'number' then
		
							quantity = ESX.Math.Round(quantity)
		
						else

							post = false
							ESX.ShowNotification("Montant Invalide")
						end

					end

					if joueurProche == true then

						if post == true then

							TriggerServerEvent('esx:givecash', GetPlayerServerId(closestPlayer), quantity)

							CreateThread(function ()
								RageUI.CloseAll()
							end)

						else

							ESX.ShowNotification("~r~Montant Invalide")

						end

					else

						ESX.ShowNotification("~r~Aucun joueur proche.")
	
					end

				end
			end)
	
			Items:AddButton( "Jeter", nil, { IsDisabled = false}, function(onSelected)
				if (onSelected)  then

					local quantity = KeyboardInput("Montant à jeter :", "", 20)
					local post = true

					if quantity ~= nil then
		
						quantity = tonumber(quantity)

						if type(quantity) == 'number' then
		
							quantity = ESX.Math.Round(quantity)
		
						else

							post = false
							ESX.ShowNotification("Montant Invalide")
						end

					end

					if post == true  then

						TriggerServerEvent('esx:DropMoney', "money", quantity)

						CreateThread(function ()
							RageUI.CloseAll()
						end)

					else

						ESX.ShowNotification("~r~Montant Invalide")

					end
				end
			end)
		end, function()
			-- Panels
		end)

		DirtyCashSubmenu:IsVisible(function(Items)
			Items:AddButton( "Donner", nil, { IsDisabled = false}, function(onSelected)
				if (onSelected) then

					local joueurProche = false

					closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	
					if closestDistance ~= -1 and closestDistance <= 3 then
	
						joueurProche = true
	
					end

					local quantity = KeyboardInput("Montant à jeter :", "", 20)
					local post = true

					if quantity ~= nil then
		
						quantity = tonumber(quantity)

						if type(quantity) == 'number' then
		
							quantity = ESX.Math.Round(quantity)
		
						else

							post = false
							ESX.ShowNotification("Montant Invalide")
						end

					end

					if joueurProche == true then

						if post == true then

							TriggerServerEvent('esx:givecash', GetPlayerServerId(closestPlayer), quantity)

							CreateThread(function ()
								RageUI.CloseAll()
							end)

						else

							ESX.ShowNotification("~r~Montant Invalide")

						end

					else

						ESX.ShowNotification("~r~Aucun joueur proche.")
	
					end

				end
			end)
	
			Items:AddButton( "Jeter", nil, { IsDisabled = false}, function(onSelected)
				if (onSelected)  then

					local quantity = KeyboardInput("Montant à jeter :", "", 20)
					local post = true

					if quantity ~= nil then
		
						quantity = tonumber(quantity)

						if type(quantity) == 'number' then
		
							quantity = ESX.Math.Round(quantity)
		
						else

							post = false
							ESX.ShowNotification("Montant Invalide")
						end

					end

					if post == true  then

						TriggerServerEvent('esx:DropMoney', "black_money", quantity)

						CreateThread(function ()
							RageUI.CloseAll()
						end)

					else

						ESX.ShowNotification("~r~Montant Invalide")

					end
				end
			end)

		end, function()
			-- Panels
		end)

		Vetement:IsVisible(function(Items)
			-- Items
			local player = PlayerPedId()

			Items:AddButton("🧥 Veste", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					ChangeVetement('torso', player)
				end
			end)

			Items:AddButton("👖 Pantalon", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					ChangeVetement('pants', player)
				end
			end)

			Items:AddButton("👟 Chaussure", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					ChangeVetement('shoes', player)
				end
			end)

			Items:AddButton("🎒 Sac", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					ChangeVetement('bag', player)
				end
			end)

		end, function()
			-- Panels
		end)

		Accessoires:IsVisible(function(Items)
			-- Items
			local player = PlayerPedId()

			Items:AddButton("👺 Masque", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					startAnimAction('misscommon@van_put_on_masks', 'put_on_mask_rds')

					Citizen.Wait(1000)
	
					ClearPedTasks(player)

					SetUnsetAccessory('Mask')
				end
			end)

			Items:AddButton("🎓 Chapeau / Casquette", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					startAnimAction('missheist_agency2ahelmet', 'take_off_helmet_stand')

					Citizen.Wait(1000)
	
					ClearPedTasks(player)

					SetUnsetAccessory('Helmet')
				end
			end)

			Items:AddButton("👂 Accessoires d'oreilles", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					startAnimAction('mini@ears_defenders', 'takeoff_earsdefenders_idle')

					Citizen.Wait(1000)
	
					ClearPedTasks(player)

					SetUnsetAccessory('Ears')
				end
			end)

			Items:AddButton("👀  Lunettes", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					startAnimAction('clothingspecs', 'take_off')

					Citizen.Wait(1000)
	
					ClearPedTasks(player)

					SetUnsetAccessory('Glasses')
				end
			end)

		end, function()
			-- Panels
		end)

		Societe:IsVisible(function(Items)
			-- Items
			Items:AddSeparator("~y~Société ~s~: " .. ESX.PlayerData.job.label)

			Items:AddSeparator("~h~Capital~h~ ~y~Société ~s~: " .. societymoney .. " ~g~$")

			Items:AddSeparator("↓ ~y~~h~Gestion~h~~s~ de la ~y~Société~s~ ↓")

			Items:AddButton("🖊 Recruter une personne", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					if ESX.PlayerData.job.grade_name == 'boss' then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	
						if closestPlayer == -1 or closestDistance > 3.0 then
							ESX.ShowNotification("~r~Personne à proximité")
						else
							TriggerServerEvent('Xel_F5:Recruit', GetPlayerServerId(closestPlayer))
						end
					else
						ESX.ShowNotification("Tu n'est pas le patron")
					end
				end
			end)

			Items:AddButton("📈 Promouvoir une personne", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					if ESX.PlayerData.job.grade_name == 'boss' then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	
						if closestPlayer == -1 or closestDistance > 3.0 then
							ESX.ShowNotification("~r~Personne à proximité")
						else
							TriggerServerEvent('Xel_f5:Promote', GetPlayerServerId(closestPlayer))
						end
					else
						ESX.ShowNotification("Tu n'est pas le patron")
					end
				end
			end)

			Items:AddButton("📉 Retrograder une personne", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					if ESX.PlayerData.job.grade_name == 'boss' then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	
						if closestPlayer == -1 or closestDistance > 3.0 then
							ESX.ShowNotification("~r~Personne à proximité")
						else
							TriggerServerEvent('Xel_f5:Demote', GetPlayerServerId(closestPlayer))
						end
					else
						ESX.ShowNotification("Tu n'est pas le patron")
					end
				end
			end)

			Items:AddButton("📦 Licencier une personne", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					if ESX.PlayerData.job.grade_name == 'boss' then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	
						if closestPlayer == -1 or closestDistance > 3.0 then
							ESX.ShowNotification("~r~Personne à proximité")
						else
							TriggerServerEvent('Xel_f5:Fire', GetPlayerServerId(closestPlayer))
						end
					else
						ESX.ShowNotification("Tu n'est pas le patron")
					end
				end
			end)

		end, function()
			-- Panels
		end)

		Orga:IsVisible(function(Items)
			-- Items
			Items:AddSeparator("~r~Organisation ~s~: ~c~" .. ESX.PlayerData.job2.label)

			Items:AddSeparator("~h~Capital~h~ ~r~Organisation ~s~: " .. societymoney2 .. " ~g~$")

			Items:AddSeparator("↓ ~r~~h~Gestion~h~~s~ de ~r~l'Organisation~s~ ↓")
			
			Items:AddButton("🩸 Recruter un membre", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					if ESX.PlayerData.job2.grade_name == 'boss' then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	
						if closestPlayer == -1 or closestDistance > 3.0 then
							ESX.ShowNotification("~r~Personne à proximité")
						else
							TriggerServerEvent('Xel_F5:Recruit2', GetPlayerServerId(closestPlayer))
						end
					else
						ESX.ShowNotification("Tu n'est pas le patron")
					end
				end
			end)

			Items:AddButton("♠️ Promouvoir un membre", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					if ESX.PlayerData.job2.grade_name == 'boss' then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	
						if closestPlayer == -1 or closestDistance > 3.0 then
							ESX.ShowNotification("~r~Personne à proximité")
						else
							TriggerServerEvent('Xel_f5:Promote2', GetPlayerServerId(closestPlayer))
						end
					else
						ESX.ShowNotification("Tu n'est pas le patron")
					end
				end
			end)

			Items:AddButton("♣️ Retrograder un membre", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					if ESX.PlayerData.job2.grade_name == 'boss' then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	
						if closestPlayer == -1 or closestDistance > 3.0 then
							ESX.ShowNotification("~r~Personne à proximité")
						else
							TriggerServerEvent('Xel_f5:Demote2', GetPlayerServerId(closestPlayer))
						end
					else
						ESX.ShowNotification("Tu n'est pas le patron")
					end
				end
			end)

			Items:AddButton("🔪 Virer un membre", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					if ESX.PlayerData.job2.grade_name == 'boss' then
						local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
	
						if closestPlayer == -1 or closestDistance > 3.0 then
							ESX.ShowNotification("~r~Personne à proximité")
						else
							TriggerServerEvent('Xel_f5:Fire2', GetPlayerServerId(closestPlayer))
						end
					else
						ESX.ShowNotification("Tu n'est pas le patron")
					end
				end
			end)

		end, function()
			-- Panels
		end)

		Vehicule:IsVisible(function(Items)
			-- Items

			local vehicule = GetVehiclePedIsIn(PlayerPedId(), false)

			local etat = math.floor(GetVehicleBodyHealth(vehicule --[[ Vehicle ]])//10)


			if etat >= 65 then
				color = "~g~"
			elseif etat < 65 and etat >= 35 then
				color = "~o~"
			elseif etat < 35 and etat >= 0 then
				color = "~r~"
			end

			Items:AddSeparator("↓ ~b~Information~s~ du ~b~Véhicule~s~ ↓")

			Items:AddSeparator("Etat du véhicule : "..color .. etat .. "%")


			Items:AddButton("🔧 ~r~Eteindre~s~/~g~Allumer~s~ le moteur", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then

					if GetIsVehicleEngineRunning(vehicule) then
						SetVehicleEngineOn(vehicule, false, false, true)
						SetVehicleUndriveable(vehicule, true)
					elseif not GetIsVehicleEngineRunning(vehicule) then
						SetVehicleEngineOn(vehicule, true, false, true)
						SetVehicleUndriveable(vehicule, false)
					end
				end
			end)

			Items:AddButton("🔑 ~r~Verrouiller~s~/~g~Déverouiller~s~ les portes", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					if 	GetVehicleDoorLockStatus(vehicule) == 1 then 
						SetVehicleDoorsLocked(vehicule --[[ Vehicle ]], 4 --[[ integer ]]) -- 4 veux dire que les  gens son bloquer dedans + de RP
						ESX.ShowNotification("Porte ~r~Vérouiller")
					else
						SetVehicleDoorsLocked(vehicule --[[ Vehicle ]], 1 --[[ integer ]])
						ESX.ShowNotification("Porte ~g~Dévérouiller")
					end
				end
			end)

			Items:AddList("🚘 Porte du véhicule", DoorList, DoorIndex, nil, { IsDisabled = false }, function(Index, onSelected, onListChange)
				if (onListChange) then
					DoorIndex = Index;
				end

				if (onSelected) then

					if Index == 1 then 
						if avantg == false then
							avantg = true
							SetVehicleDoorOpen(vehicule, 0, false, false)
						elseif avantg == true then
							avantg = false
							SetVehicleDoorShut(vehicule, 0, false, false)
						end
					elseif Index == 2 then
						if avantd == false then
							avantd = true
							SetVehicleDoorOpen(vehicule, 1, false, false)
						elseif avantd == true then
							avantd = false
							SetVehicleDoorShut(vehicule, 1, false, false)
						end
					elseif Index == 3 then
						if arriereg == false then
							arriereg = true
							SetVehicleDoorOpen(vehicule, 2, false, false)
						elseif arriereg == true then
							arriereg = false
							SetVehicleDoorShut(vehicule, 2, false, false)
						end
					elseif Index == 4 then
						if arriered == false then
							arriered = true
							SetVehicleDoorOpen(vehicule, 3, false, false)
						elseif arriered == true then
							arriered = false
							SetVehicleDoorShut(vehicule, 3, false, false)
						end
					elseif Index == 5 then
						if capot == false then
							capot = true
							SetVehicleDoorOpen(vehicule, 4, false, false)
						elseif capot == true then
							capot = false
							SetVehicleDoorShut(vehicule, 4, false, false)
						end
					elseif Index == 6 then
						if coffre == false then
							coffre = true
							SetVehicleDoorOpen(vehicule, 5, false, false)
						elseif coffre == true then
							coffre = false
							SetVehicleDoorShut(vehicule, 5, false, false)
						end
					end
			
				end
				
			end)


		end, function()
			-- Panels
		end)

		Admin:IsVisible(function(Items)
			-- Items
			Items:CheckBox("⚜️ Mode Staff", nil, Checked, { Style = 1 }, function(onSelected, IsChecked)
				if (onSelected) then
					Checked = IsChecked
				end
			end)

			if Checked then
				Items:AddSeparator("Bonjour ~p~"..	GetPlayerName(PlayerId()) .. "~s~ !")

				Items:AddButton("😄 Joueurs", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)

				end, AdminJoueur)

				Items:AddButton("📌 Téléportation", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)

				end, AdminTP)

				Items:AddButton("🚘 Véhicule", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)

				end, AdminVehicule)

				-- Items:AddButton("⚔️ Sanction", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)

				-- end, AdminSanction)

			end

		end, function()
			-- Panels
		end)


		AdminJoueur:IsVisible(function(Items)
			-- Items

			Items:AddButton("👻 NoClip", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					AdminNoClip()
				end
			end)

			Items:AddButton("🧲 Bring", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					local plyId = KeyboardInput("Id du Joueur :", "", 20)

					if plyId ~= nil then
						plyId = tonumber(plyId)
						
						if type(plyId) == 'number' then
							ExecuteCommand("bring " .. plyId)
						end
					end
				end
			end)

			Items:AddButton("🔗 GoTo", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					local plyId = KeyboardInput("Id du Joueur :", "", 20)

					if plyId ~= nil then
						plyId = tonumber(plyId)
						
						if type(plyId) == 'number' then
							ExecuteCommand("goto " .. plyId)
						end
					end
				end
			end)

			Items:AddButton("🦾 Invincible", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					local plyPed = PlayerPedId()
					
					godmode = not godmode

					if godmode then
						SetEntityInvincible(plyPed, true)
						ESX.ShowNotification("Mode Invincible ~g~Activer")
					else
						SetEntityInvincible(plyPed, false)
						ESX.ShowNotification("Mode Invincible ~r~Désactiver")
					end
				end
			end)

			Items:AddButton("👀 Invisible", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					local plyPed = PlayerPedId()
					ghostmode = not ghostmode

					if ghostmode then
						SetEntityVisible(plyPed, false, false)
						ESX.ShowNotification("Mode Invisible ~g~Activer")
					else
						SetEntityVisible(plyPed, true, false)
						ESX.ShowNotification("Mode Invisible ~r~Désactiver")
					end
				end
			end)

			Items:AddButton("👁‍🗨 Voir les Noms", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					showName = not showName

					if not showname then
						for targetPlayer, gamerTag in pairs(gamerTags) do
							RemoveMpGamerTag(gamerTag)
							gamerTags[targetPlayer] = nil
						end
						ESX.ShowNotification("Vision des Noms ~g~Activer !")
					else
						ESX.ShowNotification("Vision des Noms ~r~Désactiver !")
					end
				end
			end)

			Items:AddButton("🩹 Revive", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					local plyId = KeyboardInput("Id du Joueur :", "", 20)

					if plyId ~= nil then
						plyId = tonumber(plyId)
						
						if type(plyId) == 'number' then
							ExecuteCommand("revive " .. plyId)
						end
					end
				end
			end)

			Items:AddButton("🩺 Revive All", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					ExecuteCommand("reviveall")
				end
			end)

			Items:AddButton("🗺️ Voirs Coordonnées", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					showCoords = not showCoords
				end
			end)

			Items:AddButton("💵 Give Argent Cash", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					local amount = KeyboardInput("Montant à give :", "", 20)

					if amount ~= nil then
						amount = tonumber(amount)
		
						if type(amount) == 'number' then
							ExecuteCommand("giveaccountmoney " .. GetPlayerServerId(PlayerId()) .. " money " .. amount)
							TriggerServerEvent('Xel_F5:SendWebhook', GetPlayerName(PlayerId()), "Give Argent", " - Vien de se give " .. amount .. "$ en Cash", "9491047")
						end
					end
				end
			end)

			Items:AddButton("💶 Give Argent Banque", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					local amount = KeyboardInput("Montant à give :", "", 20)

					if amount ~= nil then
						amount = tonumber(amount)
		
						if type(amount) == 'number' then
							ExecuteCommand("giveaccountmoney " .. GetPlayerServerId(PlayerId()) .. " bank " .. amount)
							TriggerServerEvent('Xel_F5:SendWebhook', GetPlayerName(PlayerId()), "Give Argent", " - Vien de se give " .. amount .. "$ en Bank", "9491047")
						end
					end
				end
			end)

			Items:AddButton("💷 Give Argent Sale", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					local amount = KeyboardInput("Montant à give :", "", 20)

					if amount ~= nil then
						amount = tonumber(amount)
		
						if type(amount) == 'number' then
							ExecuteCommand("giveaccountmoney " .. GetPlayerServerId(PlayerId()) .. " black_money " .. amount)
							TriggerServerEvent('Xel_F5:SendWebhook', GetPlayerName(PlayerId()), "Give Argent", " - Vien de se give " .. amount .. "$ en Sale", "15285773")
						end
					end
				end
			end)

			Items:AddButton("👹 Changer de Skin", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					Citizen.Wait(500)
					TriggerEvent('esx_skin:openSaveableMenu')
					CreateThread(function ()
						RageUI.CloseAll()
					end)
				end
			end)

		end, function()
			-- Panels
		end)

		AdminTP:IsVisible(function(Items)
			-- Items

			Items:AddButton("📍 Téléportation Marker", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					TpSurMarker()
				end
			end)

			Items:AddButton("🧭 Téléportation coordonnées", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					local x = KeyboardInput("Axe X :", "", 20)
					local y = KeyboardInput("Axe Y :", "", 20)
					local z = KeyboardInput("Axe Z :", "", 20)

					if x ~= nil and y ~= nil and z ~= nil then
						x = tonumber(x)
						y = tonumber(y)
						z = tonumber(z)
						
						if type(x) == 'number' and type(y) == 'number' and  type(z) == 'number' then
							print(plyId)
							ExecuteCommand("setcoords " .. x .. " " .. y .. " " .. z)
						end
					end
				end
			end)

			Items:AddButton("🚧 Téléportation Parking Central", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					local x = 219.6
					local y = -801.5
					local z = 30.7+1
					ExecuteCommand("setcoords " .. x .. " " .. y .. " " .. z)
				end
			end)

			Items:AddButton("🏨 Téléportation Hôpital", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					local x = 297.8
					local y = -579.4
					local z = 43.1+1
					ExecuteCommand("setcoords " .. x .. " " .. y .. " " .. z)
				end
			end)

			Items:AddButton("🏢 Téléportation Concess", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					local x = -36.8
					local y = -1105.3
					local z = 26.4+1
					ExecuteCommand("setcoords " .. x .. " " .. y .. " " .. z)
				end
			end)

		end, function()
			-- Panels
		end)

		AdminVehicule:IsVisible(function(Items)
			-- Items

			Items:AddButton("☄️ Faire apparaitre un véhicule", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					local vehicle = KeyboardInput("Model du véhicule :", "", 20)

					if vehicle ~= nil then
						vehicle = tostring(vehicle)
						ExecuteCommand("car " .. vehicle)
						ESX.ShowNotification("Apparition de votre ~p~" .. vehicle .. "~s~ ~g~Effectuée~s~ !")
						TriggerServerEvent('Xel_F5:SendWebhook', GetPlayerName(PlayerId()), "Véhicule", " - Vien de faire apparaitre une " .. vehicle, "7634885")
					end
				end
			end)

			Items:AddButton("🔧 Réparer un véhicule", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					local plyPed = PlayerPedId()
					local plyVeh = GetVehiclePedIsIn(plyPed, false)
					SetVehicleFixed(plyVeh)
					SetVehicleDirtLevel(plyVeh, 0.0)
					ESX.ShowNotification("Réparation ~g~Effectuée~s~ !")
				end
			end)

			Items:AddButton("🔃 Retourner un véhicule", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					local plyPed = PlayerPedId()
					local plyCoords = GetEntityCoords(plyPed)
					local newCoords = plyCoords + vector3(0.0, 2.0, 0.0)
					local closestVeh = GetClosestVehicle(plyCoords, 10.0, 0, 70)
		
					SetEntityCoords(closestVeh, newCoords)
					ESX.ShowNotification("Véhicule ~g~Retourné~s~ !")
				end
			end)

			Items:AddButton("🗑️ Supprimer un véhicule", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					ExecuteCommand("dv")
					ESX.ShowNotification("Véhicule ~g~Supprimé~s~ !")
				end
			end)

			Items:AddButton("🗑️ Supprimer plusieurs véhicule", nil, { IsDisabled = false, RightLabel = "~m~→→" }, function(onSelected)
				if  (onSelected) then
					local rayon = KeyboardInput("Rayon de supression :", "100", 20)

					if rayon ~= nil then
						rayon = tonumber(rayon)
						
						if type(rayon) == 'number' then
							ExecuteCommand("dv " .. rayon)
							ESX.ShowNotification("~p~" .. math.random(10,999) .. " ~s~Véhicules ~g~Supprimés~s~ !")
						end
					end
				end
			end)

		end, function()
			-- Panels
		end)
	end
	RageUI.Visible(MainMenu, not RageUI.Visible(MainMenu))
end

--Message text joueur
function Text(text)
	SetTextColour(186, 186, 186, 255)
	SetTextFont(0)
	SetTextScale(1.378, 0.378)
	-- SetTextWrap(0.0, 1.0)
	SetTextCentre(false)
	SetTextDropshadow(0, 0, 0, 0, 255)
	SetTextEdge(1, 0, 0, 0, 205)
	BeginTextCommandDisplayText('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayText(0.39, 0.90)
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)

	-- TextEntry		-->	The Text above the typing field in the black square
	-- ExampleText		-->	An Example Text, what it should say in the typing field
	-- MaxStringLenght	-->	Maximum String Lenght

	AddTextEntry('FMMC_KEY_TIP1', TextEntry) --Sets the Text above the typing field in the black square
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght) --Actually calls the Keyboard Input
	blockinput = true --Blocks new input while typing if **blockinput** is used

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do --While typing is not aborted and not finished, this loop waits
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult() --Gets the result of the typing
		Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		blockinput = false --This unblocks new Input when typing is done
		return result --Returns the result
	else
		Citizen.Wait(500) --Little Time Delay, so the Keyboard won't open again if you press enter to finish the typing
		blockinput = false --This unblocks new Input when typing is done
		return nil --Returns nil if the typing got aborted
	end
end

function startAnimAction(lib, anim)

	local  player = PlayerPedId()

	ESX.Streaming.RequestAnimDict(lib, function()

		TaskPlayAnim(player, lib, anim, 8.0, 1.0, -1, 49, 0, false, false, false)

	end)

end

function ChangeVetement(value, player)

	ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)

		TriggerEvent('skinchanger:getSkin', function(skina)

			if value == 'torso' then

				startAnimAction('clothingtie', 'try_tie_neutral_a')

				Citizen.Wait(1000)

				ClearPedTasks(player)



				if skin.torso_1 ~= skina.torso_1 then

					TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = skin.torso_1, ['torso_2'] = skin.torso_2, ['tshirt_1'] = skin.tshirt_1, ['tshirt_2'] = skin.tshirt_2, ['arms'] = skin.arms})

				else

					TriggerEvent('skinchanger:loadClothes', skina, {['torso_1'] = 15, ['torso_2'] = 0, ['tshirt_1'] = 15, ['tshirt_2'] = 0, ['arms'] = 15})

				end

			elseif value == 'pants' then

				startAnimAction('clothingtrousers', 'outro')

				Citizen.Wait(1000)

				ClearPedTasks(player)

				if skin.pants_1 ~= skina.pants_1 then

					TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = skin.pants_1, ['pants_2'] = skin.pants_2})

				else

					if skin.sex == 0 then

						TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 61, ['pants_2'] = 1})

					else

						TriggerEvent('skinchanger:loadClothes', skina, {['pants_1'] = 15, ['pants_2'] = 0})

					end

				end

			elseif value == 'shoes' then

				startAnimAction('clothingshoes', 'check_out_a')

				Citizen.Wait(1000)

				ClearPedTasks(player)

				if skin.shoes_1 ~= skina.shoes_1 then

					TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = skin.shoes_1, ['shoes_2'] = skin.shoes_2})

				else

					if skin.sex == 0 then

						TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 34, ['shoes_2'] = 0})

					else

						TriggerEvent('skinchanger:loadClothes', skina, {['shoes_1'] = 35, ['shoes_2'] = 0})

					end

				end

			elseif value == 'bag' then

				startAnimAction('clothingtie', 'try_tie_positive_b')

				Citizen.Wait(1000)

				ClearPedTasks(player)

				if skin.bags_1 ~= skina.bags_1 then

					TriggerEvent('skinchanger:loadClothes', skina, {['bags_1'] = skin.bags_1, ['bags_2'] = skin.bags_2})

				else

					TriggerEvent('skinchanger:loadClothes', skina, {['bags_1'] = 0, ['bags_2'] = 0})

				end

			elseif value == 'bproof' then

				startAnimAction('clothingtie', 'try_tie_neutral_a')

				Citizen.Wait(1000)

				handsup, pointing = false, false

				ClearPedTasks(player)



				if skin.bproof_1 ~= skina.bproof_1 then

					TriggerEvent('skinchanger:loadClothes', skina, {['bproof_1'] = skin.bproof_1, ['bproof_2'] = skin.bproof_2})

				else

					TriggerEvent('skinchanger:loadClothes', skina, {['bproof_1'] = 0, ['bproof_2'] = 0})

				end

			end

		end)

	end)

end

function SetUnsetAccessory(accessory)
	ESX.TriggerServerCallback('esx_accessories:get', function(hasAccessory, accessorySkin)
		local _accessory = string.lower(accessory)

		if hasAccessory then
			TriggerEvent('skinchanger:getSkin', function(skin)
				local mAccessory = -1
				local mColor = 0

				if _accessory == "mask" then
					mAccessory = 0
				end

				if skin[_accessory .. '_1'] == mAccessory then
					mAccessory = accessorySkin[_accessory .. '_1']
					mColor = accessorySkin[_accessory .. '_2']
				end

				local accessorySkin = {}
				accessorySkin[_accessory .. '_1'] = mAccessory
				accessorySkin[_accessory .. '_2'] = mColor
				TriggerEvent('skinchanger:loadClothes', skin, accessorySkin)
			end)
		else
			ESX.ShowNotification("Vous n'avez pas cet ~r~accessoire~s~ !")
		end
	end, accessory)
end

function RefreshMoney()

	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then

		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)

			UpdateSocietyMoney(money)

		end, ESX.PlayerData.job.name)

	end

end



function RefreshMoney2()

	if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' then

		ESX.TriggerServerCallback('esx_society:getSocietyMoney', function(money)

			UpdateSociety2Money(money)

		end, ESX.PlayerData.job2.name)

	end

end



RegisterNetEvent('esx_addonaccount:setMoney')

AddEventHandler('esx_addonaccount:setMoney', function(society, money)

	if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job.name == society then

		UpdateSocietyMoney(money)

	end

	if ESX.PlayerData.job2 ~= nil and ESX.PlayerData.job2.grade_name == 'boss' and 'society_' .. ESX.PlayerData.job2.name == society then

		UpdateSociety2Money(money)

	end

end)

function UpdateSocietyMoney(money)

	societymoney = ESX.Math.GroupDigits(money)

end

function UpdateSociety2Money(money)

	societymoney2 = ESX.Math.GroupDigits(money)

end

function getCamDirection()
	local plyPed = PlayerPedId()
	local heading = GetGameplayCamRelativeHeading() + GetEntityPhysicsHeading(plyPed)
	local pitch = GetGameplayCamRelativePitch()
	local coords = vector3(-math.sin(heading * math.pi / 180.0), math.cos(heading * math.pi / 180.0), math.sin(pitch * math.pi / 180.0))
	local len = math.sqrt((coords.x * coords.x) + (coords.y * coords.y) + (coords.z * coords.z))

	if len ~= 0 then
		coords = coords / len
	end

	return coords
end

function AdminNoClip()

	noclip = not noclip

	local plyPed = PlayerPedId()


	if noclip then
		FreezeEntityPosition(plyPed, true)
		SetEntityInvincible(plyPed, true)
		SetEntityCollision(plyPed, false, false)

		SetEntityVisible(plyPed, false, false)

		SetEveryoneIgnorePlayer(PlayerId(), true)
		SetPoliceIgnorePlayer(PlayerId(), true)
		ESX.ShowNotification("NoClip ~g~Activer")
		TriggerServerEvent('Xel_F5:SendWebhook', GetPlayerName(PlayerId()), "NoClip", " - Vien d'activer son NoClip", "14772145")
	else
		FreezeEntityPosition(plyPed, false)
		SetEntityInvincible(plyPed, false)
		SetEntityCollision(plyPed, true, true)

		SetEntityVisible(plyPed, true, false)

		SetEveryoneIgnorePlayer(PlayerId(), false)
		SetPoliceIgnorePlayer(PlayerId(), false)
		ESX.ShowNotification("NoClip ~r~Désactiver")
		TriggerServerEvent('Xel_F5:SendWebhook', GetPlayerName(PlayerId()), "NoClip", " - Vien de désactiver son NoClip", "14772145")
	end

end

function TpSurMarker()
	local plyPed = PlayerPedId()
	ESX.TriggerServerCallback('Xel_F5:GetUserAdmin', function(plyGroup)
		if plyGroup ~= nil and (plyGroup == 'mod' or plyGroup == 'admin' or plyGroup == 'superadmin' or plyGroup == 'owner' or plyGroup == '_dev') then
			local waypointHandle = GetFirstBlipInfoId(8)

			if DoesBlipExist(waypointHandle) then
				Citizen.CreateThread(function()
					local waypointCoords = GetBlipInfoIdCoord(waypointHandle)
					local foundGround, zCoords, zPos = false, -500.0, 0.0

					while not foundGround do
						zCoords = zCoords + 10.0
						RequestCollisionAtCoord(waypointCoords.x, waypointCoords.y, zCoords)
						Citizen.Wait(0)
						foundGround, zPos = GetGroundZFor_3dCoord(waypointCoords.x, waypointCoords.y, zCoords)

						if not foundGround and zCoords >= 2000.0 then
							foundGround = true
						end
					end

					SetPedCoordsKeepVehicle(plyPed, waypointCoords.x, waypointCoords.y, zPos)
					ESX.ShowNotification("Téléportation ~g~reussie~s~ !")
				end)
			else
				ESX.ShowNotification("Pas de ~r~marker~s~ sur la carte !")
			end
		end
	end)
end

Citizen.CreateThread(function()
	
	while true do

		local wait = 0

		if IsControlJustPressed(0, 166) then

			RefreshMoney()
			RefreshMoney2()

			ESX.TriggerServerCallback('Xel_F5:GetUserAdmin', function(plyGroup)
				if plyGroup ~= nil and (plyGroup == 'mod' or plyGroup == 'admin' or plyGroup == 'superadmin') then
					rang = plyGroup
					admin = false
				elseif plyGroup ~= nil and plygroup == 'user' then
					admin = true
				end
			end)

			ESX.PlayerData = ESX.GetPlayerData()

			disable = true

			OpenF5Menu()
		end

		if noclip then
			local plyPed = PlayerPedId()
			local plyCoords = GetEntityCoords(plyPed, false)
			local camCoords = getCamDirection()
			SetEntityVelocity(plyPed, 0.01, 0.01, 0.01)

			if IsControlPressed(0, 32) then
				plyCoords = plyCoords + (1.0 * camCoords)
			end

			if IsControlPressed(0, 269) then
				plyCoords = plyCoords - (1.0 * camCoords)
			end

			SetEntityCoordsNoOffset(plyPed, plyCoords, true, true, true)
		end

		if showCoords then
			local plyPed = PlayerPedId()
			local plyCoords = GetEntityCoords(plyPed, false)
			Text('~r~X~s~: ' .. ESX.Math.Round(plyCoords.x, 2) .. ' ~b~Y~s~: ' .. ESX.Math.Round(plyCoords.y, 2) .. ' ~g~Z~s~: ' .. ESX.Math.Round(plyCoords.z, 2) .. ' ~y~Angle~s~: ' .. ESX.Math.Round(GetEntityPhysicsHeading(plyPed), 2))
		end

		if IsControlPressed(1, 19) and IsControlJustReleased(1, 46) and IsInputDisabled(2) then
			TpSurMarker()
		end

		if showName then
			local plyPed = PlayerPedId()

			for k, v in ipairs(ESX.Game.GetPlayers()) do
				local otherPed = GetPlayerPed(v)

				if otherPed ~= plyPed then
					if #(GetEntityCoords(plyPed, false) - GetEntityCoords(otherPed, false)) < 5000.0 then
						gamerTags[v] = CreateFakeMpGamerTag(otherPed, ('[%s] %s'):format(GetPlayerServerId(v), GetPlayerName(v)), false, false, '', 0)
					else
						RemoveMpGamerTag(gamerTags[v])
						gamerTags[v] = nil
					end
				end
			end
		end

		Citizen.Wait(wait)
	end

end)