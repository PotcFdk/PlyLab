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

local Tag = "PlyLab"

local Frame_Width = 400
local Frame_Height = 300

PlyLab = PlyLab or {}

function PlyLab.showLabelMenu ()	
	local sid
	
	local Frame = vgui.Create("DFrame")
	Frame:SetSize(Frame_Width, Frame_Height)
	Frame:SetPos(ScrW()/2-(Frame_Width/2), ScrH()/2-(Frame_Height/2))
	Frame:SetVisible(true)
	Frame:MakePopup()
	Frame:SetTitle("PlyLab Player Labels")
	
	local Title = vgui.Create("DLabel", Frame)
	Title:SetPos(10,20)
	Title:SetSize(400,30)
	Title:SetTextColor(Color(195,15,0))
	Title:SetText("Modify a player label")
	
	local Desc = vgui.Create("DTextEntry", Frame)
	Desc:SetPos(10,50)
	Desc:SetSize(Frame_Width-20,Frame_Height-70)
	Desc:SetText("You can use this system to assign a label to a player.\n"
		.. "That label will be saved in /data/plylab, so you can use this to remember things about players.")
	Desc:SetTextColor(Color(0,0,0))
	Desc:SetDrawBackground(false)
	Desc:SetEditable(false)
	Desc:SetMultiline(true)
	
	local Info = vgui.Create("DLabel", Frame)
	Info:SetPos(90,Frame_Height-35)
	Info:SetSize(400,30)
	Info:SetTextColor(Color(195,15,0))
	Info:SetText("")
	
	local AliasLabel = vgui.Create("DLabel", Frame)
	AliasLabel:SetPos(20, 100)
	AliasLabel:SetSize(40, 20)
	AliasLabel:SetTextColor(Color(0,0,0))
	AliasLabel:SetText("Name:")
	
	local Alias = vgui.Create("DTextEntry", Frame)
	Alias:SetPos(10+50, 100)
	Alias:SetSize(Frame_Width-50-20, 20)
	Alias:SetMultiline(false)
	Alias:SetEditable(true)
	
	local LabelText = vgui.Create("DTextEntry", Frame)
	LabelText:SetPos(10, 130)
	LabelText:SetSize(Frame_Width-20, Frame_Height-130-35)
	LabelText:SetMultiline(true)
	LabelText:SetEditable(true)
	
	local DComboBox = vgui.Create("DComboBox", Frame)
	DComboBox:SetPos(Frame_Width - 160, 30)
	DComboBox:SetSize(150, 20)
	DComboBox:SetValue("Select Player...")
	
	-- ComboBox hacks, sorry.
		function DComboBox:OpenMenu(pControlOpener)
			if ( pControlOpener ) then
				if ( pControlOpener == self.LabelText ) then
					return
				end
			end
			if ( #self.Choices == 0 ) then return end
			if ( IsValid( self.Menu ) ) then
				self.Menu:Remove()
				self.Menu = nil
			end
			self.Menu = DermaMenu()
			for k, v in pairs( self.Choices ) do
				local opt = self.Menu:AddOption( v, function() self:ChooseOption( v, k ) end )
				function opt.Paint(opt, w, h)
					if PlyLab.labels[self.Data[k].sid or "N/A"] then
						surface.SetDrawColor(200,200,200,255)
					else
						surface.SetDrawColor(100,100,100,255)
					end
					surface.DrawRect(0, 0, w, h)
					derma.SkinHook( "Paint", "MenuOption", opt, w, h )
				end
			end
			local x, y = self:LocalToScreen( 0, self:GetTall() )
			self.Menu:SetMinimumWidth( self:GetWide() )
			self.Menu:Open( x, y, false, self )	
		end
	-- / ComboBox hacks
	
	do -- add entries
		local entries = {}
		
		for sid, data in next, PlyLab.labels do
			entries[sid] = { alias = data.alias }
		end
		
		for _, ply in next, player.GetAll() do
			entries[ply:SteamID()] = entries[ply:SteamID()] or {}
			entries[ply:SteamID()].nick = ply:Nick()
			entries[ply:SteamID()].alias = entries[ply:SteamID()].alias or ply:Nick()
		end
		
		for sid, entry in next, entries do
			DComboBox:AddChoice(string.format("%s%s (%s)", entry.alias or "???", 
					(entry.nick and entry.nick ~= entry.alias and " | "..entry.nick or ""), tostring(sid)),
				{alias=entry.alias, sid=sid})
		end
	end
	
	DComboBox.OnSelect = function(panel, index, value, data)
		sid = data.sid
		if istable(PlyLab.labels) and PlyLab.labels[sid] then
			Alias:SetText(isstring(data.alias) and data.alias or "")
			LabelText:SetText(PlyLab.labels[sid].label or "")
		else
			Alias:SetText("")
			LabelText:SetText("")
		end
	end
	
	local deletebutton = vgui.Create("DButton", Frame)
	deletebutton:SetText("Delete Label")
	deletebutton:SetTextColor(Color(195,15,0))
	deletebutton:SetPos(10, Frame_Height-20-10)
	deletebutton:SetSize(70, 20)
	deletebutton.DoClick = function()
		if not sid then
			Info:SetText("You have to select a player!")
			return
		end
		
		PlyLab.delete(sid)
	end
	
	local savebutton = vgui.Create("DButton", Frame)
	savebutton:SetText("Save Label")
	savebutton:SetPos(Frame_Width-140-20, Frame_Height-20-10)
	savebutton:SetSize(70, 20)
	savebutton.DoClick = function()
		if not sid then
			Info:SetText("You have to select a player!")
			return
		end
		
		if Alias:GetText():len() > 0 then
			PlyLab.setAlias(sid, Alias:GetText())
		else
			PlyLab.unsetAlias(sid)
		end
		
		if LabelText:GetText():len() > 0 then
			PlyLab.setLabel(sid, LabelText:GetText())
		else
			PlyLab.unsetLabel(sid)
		end
	end
	
	local closebutton = vgui.Create("DButton", Frame)
	closebutton:SetText("Cancel")
	closebutton:SetPos(Frame_Width-70-10, Frame_Height-20-10)
	closebutton:SetSize(70, 20)
	closebutton.DoClick = function() Frame:Close() end
end

hook.Add("OnPlayerChat", Tag, function (ply, txt)
	if ply ~= LocalPlayer() then return end
	if isstring(txt) and txt:match("^[!/~.]label") then PlyLab.showLabelMenu() end
end)