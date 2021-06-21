

rightPosition = {x = 1450, y = 100}
leftPosition = {x = 0, y = 100}
menuPosition = {x = 0, y = 200}

title = ""

if Config.MenuPosition then
  if Config.MenuPosition == "left" then
    menuPosition = leftPosition
  elseif Config.MenuPosition == "right" then
    menuPosition = rightPosition
  end
end

if Config.Logo ~= nil and Config.title ~= "" then 
  local RuntimeTXD = CreateRuntimeTxd('Custom_Menu_Head')
  local Object = CreateDui(Config.Logo, 512, 155)
  _G.Object = Object
  local TextureThing = GetDuiHandle(Object)
  local Texture = CreateRuntimeTextureFromDuiHandle(RuntimeTXD, 'Custom_Menu_Head', TextureThing)
  Menuthing = "Custom_Menu_Head"
  Config.title = ""
end


_menuPool = NativeUI.CreatePool()
mainMenu = NativeUI.CreateMenu(Config.title, "", menuPosition["x"], menuPosition["y"], Menuthing, Menuthing)
_menuPool:Add(mainMenu)


function ShowNotification(text)
  SetNotificationTextEntry("STRING")
  AddTextComponentString(text)
  DrawNotification(false, false)
end

local type = nil

function AddMainMenu(menu)

  ulow = NativeUI.CreateItem(Config.lang["ulow"], "")
  low = NativeUI.CreateItem(Config.lang["low"], "")
  mid = NativeUI.CreateItem(Config.lang["mid"], "")
  reset = NativeUI.CreateItem(Config.lang["reset"], "")
  menu:AddItem(reset)
  menu:AddItem(ulow)
  menu:AddItem(low)
  menu:AddItem(mid)

  menu.OnItemSelect = function(sender, item, index)
    if item == ulow then
      RopeDrawShadowEnabled(false)

      CascadeShadowsClearShadowSampleType()
      CascadeShadowsSetAircraftMode(false)
      CascadeShadowsEnableEntityTracker(true)
      CascadeShadowsSetDynamicDepthMode(false)
      CascadeShadowsSetEntityTrackerScale(0.0)
      CascadeShadowsSetDynamicDepthValue(0.0)
      CascadeShadowsSetCascadeBoundsScale(0.0)

      SetFlashLightFadeDistance(5.0)
      SetLightsCutoffDistanceTweak(0.0)
      DistantCopCarSirens(false)
      SetArtificialLightsState(false)
      type = "ulow"
    elseif item == low then 
      RopeDrawShadowEnabled(false)

      CascadeShadowsClearShadowSampleType()
      CascadeShadowsSetAircraftMode(false)
      CascadeShadowsEnableEntityTracker(true)
      CascadeShadowsSetDynamicDepthMode(false)
      CascadeShadowsSetEntityTrackerScale(0.0)
      CascadeShadowsSetDynamicDepthValue(0.0)
      CascadeShadowsSetCascadeBoundsScale(0.0)

      SetFlashLightFadeDistance(5.0)
      SetLightsCutoffDistanceTweak(5.0)
      DistantCopCarSirens(false)
      type = "low"
    elseif item == mid then
      RopeDrawShadowEnabled(true)

      CascadeShadowsClearShadowSampleType()
      CascadeShadowsSetAircraftMode(false)
      CascadeShadowsEnableEntityTracker(true)
      CascadeShadowsSetDynamicDepthMode(false)
      CascadeShadowsSetEntityTrackerScale(5.0)
      CascadeShadowsSetDynamicDepthValue(3.0)
      CascadeShadowsSetCascadeBoundsScale(3.0)

      SetFlashLightFadeDistance(3.0)
      SetLightsCutoffDistanceTweak(3.0)
      DistantCopCarSirens(false)
      SetArtificialLightsState(false)
      type = "medium"
    elseif item == reset then
      RopeDrawShadowEnabled(true)

      CascadeShadowsSetAircraftMode(true)
      CascadeShadowsEnableEntityTracker(false)
      CascadeShadowsSetDynamicDepthMode(true)
      CascadeShadowsSetEntityTrackerScale(5.0)
      CascadeShadowsSetDynamicDepthValue(5.0)
      CascadeShadowsSetCascadeBoundsScale(5.0)
      
      SetFlashLightFadeDistance(10.0)
      SetLightsCutoffDistanceTweak(10.0)
      DistantCopCarSirens(true)
      SetArtificialLightsState(false)
      type = nil
    end
  end
end


function OpenMenu()
  mainMenu:Visible(not mainMenu:Visible())
end

AddMainMenu(mainMenu)

_menuPool:RefreshIndex()

Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)
    _menuPool:ProcessMenus()
  end
end)


-- // Distance rendering and entity handler (need a revision)
Citizen.CreateThread(function()
    while true do
        if type == "ulow" then
            --// Find closest ped and set the alpha
            for ped in GetWorldPeds() do
                if not IsEntityOnScreen(ped) then
                    SetEntityAlpha(ped, 0)
                    SetEntityAsNoLongerNeeded(ped)
                else
                    if GetEntityAlpha(ped) == 0 then
                        SetEntityAlpha(ped, 255)
                    elseif GetEntityAlpha(ped) ~= 210 then
                        SetEntityAlpha(ped, 210)
                    end
                end

                SetPedAoBlobRendering(ped, false)
                Citizen.Wait(1)
            end

            --// Find closest object and set the alpha
            for obj in GetWorldObjects() do
                if not IsEntityOnScreen(obj) then
                    SetEntityAlpha(obj, 0)
                    SetEntityAsNoLongerNeeded(obj)
                else
                    if GetEntityAlpha(obj) == 0 then
                        SetEntityAlpha(obj, 255)
                    elseif GetEntityAlpha(obj) ~= 170 then
                        SetEntityAlpha(obj, 170)
                    end
                end
                Citizen.Wait(1)
            end


            DisableOcclusionThisFrame()
            SetDisableDecalRenderingThisFrame()
            RemoveParticleFxInRange(GetEntityCoords(PlayerPedId()), 10.0)
            OverrideLodscaleThisFrame(0.4)
            SetArtificialLightsState(false)
        elseif type == "low" then
            --// Find closest ped and set the alpha
            for ped in GetWorldPeds() do
                if not IsEntityOnScreen(ped) then
                    SetEntityAlpha(ped, 0)
                    SetEntityAsNoLongerNeeded(ped)
                else
                    if GetEntityAlpha(ped) == 0 then
                        SetEntityAlpha(ped, 255)
                    elseif GetEntityAlpha(ped) ~= 210 then
                        SetEntityAlpha(ped, 210)
                    end
                end
                SetPedAoBlobRendering(ped, false)

                Citizen.Wait(1)
            end

            --// Find closest object and set the alpha
            for obj in GetWorldObjects() do
                if not IsEntityOnScreen(obj) then
                    SetEntityAlpha(obj, 0)
                    SetEntityAsNoLongerNeeded(obj)
                else
                    if GetEntityAlpha(obj) == 0 then
                        SetEntityAlpha(obj, 255)
                    elseif GetEntityAlpha(ped) ~= 210 then
                        SetEntityAlpha(ped, 210)
                    end
                end
                Citizen.Wait(1)
            end

            SetDisableDecalRenderingThisFrame()
            RemoveParticleFxInRange(GetEntityCoords(PlayerPedId()), 10.0)
            OverrideLodscaleThisFrame(0.6)
            SetArtificialLightsState(false)
        elseif type == "medium" then
            --// Find closest ped and set the alpha
            for ped in GetWorldPeds() do
                if not IsEntityOnScreen(ped) then
                    SetEntityAlpha(ped, 0)
                    SetEntityAsNoLongerNeeded(ped)
                else
                    if GetEntityAlpha(ped) == 0 then
                        SetEntityAlpha(ped, 255)
                    end
                end

                SetPedAoBlobRendering(ped, false)
                Citizen.Wait(1)
            end
        
            --// Find closest object and set the alpha
            for obj in GetWorldObjects() do
                if not IsEntityOnScreen(obj) then
                    SetEntityAlpha(obj, 0)
                    SetEntityAsNoLongerNeeded(obj)
                else
                    if GetEntityAlpha(obj) == 0 then
                        SetEntityAlpha(obj, 255)
                    end
                end
                Citizen.Wait(1)
            end

            OverrideLodscaleThisFrame(0.8)
        else
            Citizen.Wait(500)
        end
        Citizen.Wait(8)
    end
end)

--// Clear broken thing, disable rain, disable wind and other tiny thing that dont require the frame tick
Citizen.CreateThread(function()
    while true do
        if type == "ulow" or type == "low" then
            ClearAllBrokenGlass()
            ClearAllHelpMessages()
            LeaderboardsReadClearAll()
            ClearBrief()
            ClearGpsFlags()
            ClearPrints()
            ClearSmallPrints()
            ClearReplayStats()
            LeaderboardsClearCacheData()
            ClearFocus()
            ClearHdArea()
            ClearPedBloodDamage(PlayerPedId())
            ClearPedWetness(PlayerPedId())
            ClearPedEnvDirt(PlayerPedId())
            ResetPedVisibleDamage(PlayerPedId())
            ClearExtraTimecycleModifier()
            ClearTimecycleModifier()
            ClearOverrideWeather()
            ClearHdArea()
            DisableVehicleDistantlights(false)
            DisableScreenblurFade()
            SetRainLevel(0.0)
            SetWindSpeed(0.0)
            Citizen.Wait(300)
        elseif type == "medium" then
            ClearAllBrokenGlass()
            ClearAllHelpMessages()
            LeaderboardsReadClearAll()
            ClearBrief()
            ClearGpsFlags()
            ClearPrints()
            ClearSmallPrints()
            ClearReplayStats()
            LeaderboardsClearCacheData()
            ClearFocus()
            ClearHdArea()
            SetWindSpeed(0.0)
            Citizen.Wait(1000)
        else
            Citizen.Wait(1500)
        end
    end
end)

--// Entity Enumerator (https://gist.github.com/IllidanS4/9865ed17f60576425369fc1da70259b2#file-entityiter-lua)
local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(
        function()
            local iter, id = initFunc()
            if not id or id == 0 then
                disposeFunc(iter)
                return
            end

            local enum = {handle = iter, destructor = disposeFunc}
            setmetatable(enum, entityEnumerator)

            local next = true
            repeat
                coroutine.yield(id)
                next, id = moveFunc(iter)
            until not next

            enum.destructor, enum.handle = nil, nil
            disposeFunc(iter)
        end
    )
end

function GetWorldObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

function GetWorldPeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

function GetWorldVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

function GetWorldPickups()
    return EnumerateEntities(FindFirstPickup, FindNextPickup, EndFindPickup)
end

RegisterCommand(Config.command,function()
  OpenMenu()
end)