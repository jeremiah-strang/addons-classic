local mod	= DBM:NewMod("WarchiefRendBlackhand", "DBM-Party-Classic", 4)
local L		= mod:GetLocalizedStrings()

mod:SetRevision("20200419141911")
mod:SetCreatureID(10339, 10429) -- Gyth, Rend
mod:SetMainBossID(10429)

mod:RegisterCombat("combat")
