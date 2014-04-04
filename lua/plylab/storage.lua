PlyLab = PlyLab or {}
PlyLab.Storage = PlyLab.Storage or {}

-- helpers

local function sSID (input)
	return input:gsub(":","_"):lower()
end

local function dSID (input)
	return input:gsub("(%d)_","%1:"):upper()
end

local function issteamid (sid)
	return isstring(sid) and string.match(sid, "STEAM_%d:%d:%d+") and true
end

-- PlyLab.Storage

local FileFormatVersion = 1

function PlyLab.Storage.init ()
	file.CreateDir ("plylab")
end

function PlyLab.Storage.load (ply)
	assert(issteamid(ply) or ply == nil, "Parameter #1 must be SteamID or empty!")
	
	-- No parameter? Load all.
	
	if not ply then
		for _, sid in next, (file.Find("plylab/*.txt", "DATA")) do
			sid = sid:gsub("%.txt$", "")
			sid = dSID(sid)
			print(sid)
			if issteamid(sid) then
				PlyLab.Storage.load (sid)
			end
		end
		return
	end
	
	local fh = file.Open(string.format("plylab/%s.txt", sSID(ply)), "r", "DATA")
	
	assert(fh:Read(6) == "PLYLAB" and fh:ReadByte() == 0, "File format error, unable to parse.")
	assert(fh:ReadByte() == FileFormatVersion, "Invalid format version.")
	
	local time = fh:ReadLong()
	local label = fh:Read(fh:ReadLong())	
	fh:Close()
	
	PlyLab.labels[ply] = { time = time, label = label }
end

function PlyLab.Storage.save (ply)
	assert(issteamid(ply) or ply == nil, "Parameter #1 must be SteamID or empty!")
	
	-- No parameter? Save all.
	
	if not ply then
		for steamID, data in next, PlyLab.labels do
			PlyLab.Storage.save(steamID)	
		end
		return
	end
	
	local data = PlyLab.labels[ply]
	if not istable(data) then return end
	assert(isstring(data.label) and isnumber(data.time), "Label data for " .. ply .. " is malformed!")
	
	local fh = file.Open(string.format("plylab/%s.txt", sSID(ply)), "wb", "DATA")
	fh:Write("PLYLAB")
	fh:WriteByte(0)
	fh:WriteByte(FileFormatVersion)
	fh:WriteLong(data.time)
	fh:WriteLong(string.len(data.label))
	fh:Write(data.label)
	fh:Close()
end