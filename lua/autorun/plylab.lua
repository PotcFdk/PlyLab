--[[
   PlyLab, Copyright 2014 PotcFdk

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
]]

local function AddClientsideLuaFile (path)
	if SERVER then
		return AddCSLuaFile (path)
	elseif CLIENT then
		return include (path)
	end
end

---

-- How does "LUA", "LSV", "LCL" work? I have no idea!
-- It just seems to work and break randomly.
-- So instead, I'm using all of them.

local files = {}

for _, f in next, (file.Find("plylab/*.lua", "LSV")) do
	files[f] = true
end
for _, f in next, (file.Find("plylab/*.lua", "LCL")) do
	files[f] = true
end
for _, f in next, (file.Find("plylab/*.lua", "LUA")) do
	files[f] = true
end

for f in next, files do
	AddClientsideLuaFile ("plylab/"..f)
end

-- Done.

if SERVER then
	CreateConVar("has_plylab", "1", {FCVAR_NOTIFY})
elseif CLIENT then
	PlyLab.init()
end