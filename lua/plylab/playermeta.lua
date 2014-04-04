local PLAYER = FindMetaTable("Player")

function PLAYER:GetLabel ()
	PlyLab.getLabel (self)
end

function PLAYER:SetLabel (label)
	PlyLab.setLabel (self, label)
end

function PLAYER:UnsetLabel ()
	PlyLab.unsetLabel (self)
end