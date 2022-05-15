---
--- @author Dylan MALANDAIN, Kalyptus
--- @version 1.0.0
--- File created at [24/05/2021 00:00]
---

Visual = {};

local function AddLongString(txt)
    for i = 100, string.len(txt), 99 do
        local sub = string.sub(txt, i, i + 99)
        AddTextComponentSubstringPlayerName(sub)
    end
end

function Visual.Notification(args)
    if (not args.dict) and (args.name )then
        args.dict = args.name
    end
    if not HasStreamedTextureDictLoaded(args.dict) then
        RequestStreamedTextureDict(args.dict, false)
        while not HasStreamedTextureDictLoaded(args.dict) do Wait(0) end
    end
    if (args.backId) then
        ThefeedNextPostBackgroundColor(args.backId)
    end
    BeginTextCommandThefeedPost("jamyfafi")
    if (args.message) then
        AddTextComponentSubstringPlayerName(args.message)
        if string.len(args.message) > 99 then
            AddLongString(args.message)
        end
    end
    if (args.title) and (args.subtitle) and (args.name) then
        EndTextCommandThefeedPostMessagetext(args.dict or "CHAR_DEFAULT", args.name or "CHAR_DEFAULT", true, args.icon or 0, args.title or "", args.subtitle or "")
        SetStreamedTextureDictAsNoLongerNeeded(args.dict)
    end
    EndTextCommandThefeedPostTicker(false, true)
end

function Visual.Subtitle(text, time)
    ClearPrints()
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandPrint(time and math.ceil(time) or 0, true)
end

function Visual.FloatingHelpText(text, sound, loop)
    BeginTextCommandDisplayHelp("jamyfafi")
    AddTextComponentSubstringPlayerName(text)
    if string.len(text) > 99 then
        AddLongString(text)
    end
    EndTextCommandDisplayHelp(0, loop or 0, sound or false, -1)
end

-- Au nom de dieu tu enlève le crédit tes un enculer c'est bon ?

print("^1Menu F5 RageUI par ")
print(" ")
print("^68b        d8              88                                                  ")
print("^6 Y8,    ,8P               88    ,d                                            ")
print("^6  `8b  d8'                88    88                                            ")
print("^6    Y88P       ,adPPYba,  88  MM88MMM  ,adPPYYba,  8b,     ,d8                ")
print("^6    d88b      a8P_____88  88    88            `Y8   `Y8, ,8P'                 ")
print("^6  ,8P  Y8,    8PP```````  88    88     ,adPPPPP88     )888(                   ")
print("^6 d8'    `8b   `8b,   ,aa  88    88,    88,    ,88   ,d8` `8b,                 ")
print("^68P        Y8   ``Ybbd8`'  88    `Y888  ``8bbdP`Y8  8P'     `Y8                ")
print("^1                                                                888888888888  ")
print("^1Fait avec <3")

-- Nan vraiment le supr pas sa fait plaisir au créateur !

function Visual.Prompt(text, spinner)
    BeginTextCommandBusyspinnerOn("STRING")
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandBusyspinnerOn(spinner or 1)
end

function Visual.PromptDuration(duration, text, spinner)
    Citizen.CreateThread(function()
        Citizen.Wait(0)
        Visual.Prompt(text, spinner)
        Citizen.Wait(duration)
        if (BusyspinnerIsOn()) then
            BusyspinnerOff();
        end
    end)
end

function Visual.FloatingHelpTextToEntity(text, x, y)
    SetFloatingHelpTextScreenPosition(1, x, y)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp("jamyfafi")
    AddTextComponentSubstringPlayerName(text)
    if string.len(text) > 99 then
        AddLongString(text)
    end
    EndTextCommandDisplayHelp(2, false, false, -1)
end
