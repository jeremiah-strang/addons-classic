isboxer.Character.Name = "Puzzx-Herod";
isboxer.Character.ActualName = "Puzzx";
isboxer.Character.QualifiedName = "Puzzx-Herod";

function isboxer.Character_LoadBinds()
	if (isboxer.CharacterSet.Name=="WMMLP") then
		isboxer.SetMacro("FTLAssist","BACKSPACE","/assist [nomod:alt,mod:lshift,nomod:ctrl]Puzzar;[nomod:alt,mod:rshift,nomod:ctrl]Puzzer;[nomod:alt,nomod:shift,mod:lctrl]Puzzir;[mod:lalt,nomod:shift,nomod:ctrl]Puzzx;[nomod:alt,mod:lshift,mod:lctrl]Puzzox\n",1,1,1,1);

		isboxer.SetMacro("FTLFocus","NONE","/focus [nomod:alt,mod:lshift,nomod:ctrl]Puzzar;[nomod:alt,mod:rshift,nomod:ctrl]Puzzer;[nomod:alt,nomod:shift,mod:lctrl]Puzzir;[mod:lalt,nomod:shift,nomod:ctrl]Puzzx;[nomod:alt,mod:lshift,mod:lctrl]Puzzox\n",1,1,1,1);

		isboxer.SetMacro("FTLFollow","F11","/jamba-follow snw\n/follow [nomod:alt,mod:lshift,nomod:ctrl]Puzzar;[nomod:alt,mod:rshift,nomod:ctrl]Puzzer;[nomod:alt,nomod:shift,mod:lctrl]Puzzir;[mod:lalt,nomod:shift,nomod:ctrl]Puzzx;[nomod:alt,mod:lshift,mod:lctrl]Puzzox\n",1,1,1,1);

		isboxer.SetMacro("FTLTarget","]","/targetexact [nomod:alt,mod:lshift,nomod:ctrl]Puzzar;[nomod:alt,mod:rshift,nomod:ctrl]Puzzer;[nomod:alt,nomod:shift,mod:lctrl]Puzzir;[mod:lalt,nomod:shift,nomod:ctrl]Puzzx;[nomod:alt,mod:lshift,mod:lctrl]Puzzox\n",1,1,1,1);

		isboxer.SetMacro("InviteTeam","ALT-CTRL-SHIFT-I","/invite Puzzar\n/invite Puzzer\n/invite Puzzir\n/invite Puzzox\n",nil,nil,nil,1);

		isboxer.SetMacro("CTMOn","ALT-SHIFT-N","/console autointeract 1\n",nil,nil,nil,1);

		isboxer.SetMacro("CTMOff","ALT-CTRL-N","/console autointeract 0\n",nil,nil,nil,1);

		isboxer.SetMacro("JambaMaster","CTRL-SHIFT-F12","/jamba-team iammaster all\n",nil,nil,nil,1);

		isboxer.SetMacro("JambaStrobeOn","ALT-SHIFT-F12","/jamba-follow strobeonme all\n",nil,nil,nil,1);

		isboxer.SetMacro("JambaStrobeOff","ALT-CTRL-SHIFT-F12","/jamba-follow strobeoff all\n",nil,nil,nil,1);

		isboxer.ManageJambaTeam=True
		isboxer.ClearMembers();
		isboxer.AddMember("Puzzar-Herod");
		isboxer.AddMember("Puzzer-Herod");
		isboxer.AddMember("Puzzir-Herod");
		isboxer.AddMember("Puzzx-Herod");
		isboxer.AddMember("Puzzox-Herod");
		isboxer.SetMaster("Puzzar-Herod");
		return
	end
end
isboxer.Character.LoadBinds = isboxer.Character_LoadBinds;

isboxer.Output("Character 'Puzzx-Herod' activated");
