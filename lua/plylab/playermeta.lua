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

local PLAYER = FindMetaTable("Player")

function PLAYER:GetLabel ()
	return PlyLab.getLabel (self)
end

function PLAYER:HasLabel ()
	return self:GetLabel () and true or false
end

function PLAYER:SetLabel (label)
	return PlyLab.setLabel (self, label)
end

function PLAYER:UnsetLabel ()
	return PlyLab.unsetLabel (self)
end

function PLAYER:GetAlias ()
	return PlyLab.getAlias (self)
end

function PLAYER:HasAlias ()
	return self:GetAlias () and true or false
end

function PLAYER:SetAlias (label)
	return PlyLab.setAlias (self, label)
end

function PLAYER:UnsetAlias ()
	return PlyLab.unsetAlias (self)
end