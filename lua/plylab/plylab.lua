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