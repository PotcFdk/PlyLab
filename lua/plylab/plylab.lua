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

PlyLab.labels = PlyLab.labels or {}

function PlyLab.unsetLabel (ply)
	if type(ply) == "Player" then
		assert(IsValid(ply), "Invalid player.")
		ply = ply:SteamID()
	end
	assert(isstring(ply), "Invalid SteamID.")
	
	PlyLab.labels[ply] = nil
	
	-- TODO
end

function PlyLab.setLabel (ply, label)
	if type(ply) == "Player" then
		assert(IsValid(ply), "Invalid player.")
		ply = ply:SteamID()
	end
	assert(isstring(ply), "Invalid SteamID.")

	label = string.Trim(label)
	if string.len(label) == 0 then 
		return PlyLab.unsetLabel(ply)
	end
	
	PlyLab.labels[ply] = PlyLab.labels[ply] or {}
	PlyLab.labels[ply].label = label
	PlyLab.labels[ply].time = os.time()
	
	-- TODO
end

function PlyLab.getLabel (ply)
	if type(ply) == "Player" then
		assert(IsValid(ply), "Invalid player.")
		ply = ply:SteamID()
	end
	assert(isstring(ply), "Invalid SteamID.")
	
	return PlyLab.labels[ply] and PlyLab.labels[ply].label
	
	-- TODO
end