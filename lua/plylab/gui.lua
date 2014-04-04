local Tag = "PlyLab"

local Frame_Width = 400
local Frame_Height = 300

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
	
	local TextEntry = vgui.Create("DTextEntry", Frame)
	TextEntry:SetPos(10, 100)
	TextEntry:SetSize(Frame_Width-20, Frame_Height-100-35)
	TextEntry:SetMultiline(true)
	TextEntry:SetEditable(true)
	
	local DComboBox = vgui.Create("DComboBox", Frame)
	DComboBox:SetPos(Frame_Width - 160, 30)
	DComboBox:SetSize(150, 20)
	DComboBox:SetValue("Select Player...")
	
	-- ComboBox hacks, sorry.
		function DComboBox:OpenMenu(pControlOpener)
			if ( pControlOpener ) then
				if ( pControlOpener == self.TextEntry ) then
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
				print(opt)
				function opt.Paint(opt, w, h)
					if PlyLab.labels[self.Data[k] or "N/A"] then
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
			entries[sid] = data.nick or true
		end
		
		for _, ply in next, player.GetAll() do
			entries[ply:SteamID()] = ply:Nick()
		end
		
		for sid, nick in next, entries do
			DComboBox:AddChoice(string.format("%s (%s)", isstring(nick) and nick or "???", tostring(sid)), sid)
		end
	end
	
	DComboBox.OnSelect = function(panel, index, value, data)
		sid = data
		if istable(PlyLab.labels) and PlyLab.labels[data] and isstring(PlyLab.labels[data].label) then
			TextEntry:SetText(PlyLab.labels[sid].label)
		else
			TextEntry:SetText("")
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
		
		PlyLab.unsetLabel(sid)
		
		Frame:Close()
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
		
		PlyLab.setLabel(sid, TextEntry:GetText())
		
		Frame:Close()
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