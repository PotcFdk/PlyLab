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

PlyLab = PlyLab or {}

function PlyLab.init ()
	PlyLab.Storage.init()
	PlyLab.Storage.load()
end

PlyLab.labels = PlyLab.labels or {}

function PlyLab.delete (ply)
	if type(ply) == "Player" then
		assert(IsValid(ply), "Invalid player.")
		ply = ply:SteamID()
	end
	assert(isstring(ply), "Invalid SteamID.")
	
	PlyLab.labels[ply] = nil
	
	PlyLab.Storage.delete (ply)
end

function PlyLab.unsetLabel (ply)
	if type(ply) == "Player" then
		assert(IsValid(ply), "Invalid player.")
		ply = ply:SteamID()
	end
	assert(isstring(ply), "Invalid SteamID.")
	
	local data = PlyLab.labels[ply]
	
	if not istable(data) then return end
	
	data.label = nil
	data.time = os.time()
	
	PlyLab.Storage.save (ply)
end

function PlyLab.setLabel (ply, label)
	if type(ply) == "Player" then
		assert(IsValid(ply), "Invalid player.")
		ply = ply:SteamID()
	end
	assert(isstring(ply), "Invalid SteamID.")
	
	PlyLab.labels[ply] = PlyLab.labels[ply] or {}
	local data = PlyLab.labels[ply]
	data.label = label
	data.time = os.time()
	
	PlyLab.Storage.save (ply)
end

function PlyLab.getLabel (ply)
	if type(ply) == "Player" then
		assert(IsValid(ply), "Invalid player.")
		ply = ply:SteamID()
	end
	assert(isstring(ply), "Invalid SteamID.")
	
	return PlyLab.labels[ply] and PlyLab.labels[ply].label
end

function PlyLab.unsetAlias (ply)
	if type(ply) == "Player" then
		assert(IsValid(ply), "Invalid player.")
		ply = ply:SteamID()
	end
	assert(isstring(ply), "Invalid SteamID.")
	
	local data = PlyLab.labels[ply]
	
	if not istable(data) then return end
	
	data.alias = nil
	data.time = os.time()
	
	PlyLab.Storage.save (ply)
end

function PlyLab.setAlias (ply, alias)
	if type(ply) == "Player" then
		assert(IsValid(ply), "Invalid player.")
		ply = ply:SteamID()
	end
	assert(isstring(ply), "Invalid SteamID.")
	
	PlyLab.labels[ply] = PlyLab.labels[ply] or {}
	local data = PlyLab.labels[ply]
	data.alias = alias
	data.time = os.time()
	
	PlyLab.Storage.save (ply)
end

function PlyLab.getAlias (ply)
	if type(ply) == "Player" then
		assert(IsValid(ply), "Invalid player.")
		ply = ply:SteamID()
	end
	assert(isstring(ply), "Invalid SteamID.")
	
	return PlyLab.labels[ply] and PlyLab.labels[ply].alias
end