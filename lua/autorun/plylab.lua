local function AddClientsideLuaFile (path)
	if SERVER then
		return AddCSLuaFile (path)
	elseif CLIENT then
		return include (path)
	end
end

for _, f in next, (file.Find("plylab/*.lua", SERVER and "LSV" or "LCL")) do
	AddClientsideLuaFile ("plylab/"..f)
end