SWEP.Base = "homigrad_base"
SWEP.Spawnable = true
SWEP.AdminOnly = false
SWEP.PrintName = "Walther P22"
SWEP.Author = "Walther"
SWEP.Instructions = "Pistol chambered in .22 lr\n\nIs one of the quietest silenced guns. Slugcat."
SWEP.Category = "Weapons - Pistols"
SWEP.Slot = 2
SWEP.SlotPos = 10
SWEP.ViewModel = ""
SWEP.WorldModel = "models/weapons/w_pist_fiveseven.mdl"
SWEP.WorldModelFake = "models/weapons/zcity/c_p22.mdl"

SWEP.FakePos = Vector(-15, 2.005, 3.21)
SWEP.FakeAng = Angle(0, 0, 0)
SWEP.AttachmentPos = Vector(-1.6,-0.1,0)
SWEP.AttachmentAng = Angle(0,0,0)


SWEP.DOZVUK = true

SWEP.FakeReloadSounds = {
	[0.4] = "zcitysnd/sound/weapons/m9/handling/m9_magout.wav",

	[0.70] = "zcitysnd/sound/weapons/m9/handling/m9_magin.wav",
	[0.9] = "zcitysnd/sound/weapons/m9/handling/m9_maghit.wav",

}

SWEP.FakeEmptyReloadSounds = {
	[0.4] = "zcitysnd/sound/weapons/m9/handling/m9_magout.wav",

	[0.70] = "zcitysnd/sound/weapons/m9/handling/m9_magin.wav",
	[0.9] = "zcitysnd/sound/weapons/m9/handling/m9_maghit.wav",
	[1.05] = "zcitysnd/sound/weapons/m9/handling/m9_boltrelease.wav",
}
SWEP.MagModel = "models/weapons/zcity/c_p22.mdl"
local vector_full = Vector(1,1,1)
--models/weapons/arccw/uc_shells/22lr.mdl
SWEP.lmagpos = Vector(0,0,0)
SWEP.lmagang = Angle(0,0,0)
SWEP.lmagpos2 = Vector(0,-4.5,0.75)
SWEP.lmagang2 = Angle(0,0,0)

SWEP.FakeReloadEvents = {
	[0.2] = function( self, timeMul ) 
		if CLIENT and self:Clip1() < 1 then
			self:GetWM():SetBodygroup(1,1)
			self:GetOwner():PullLHTowards("ValveBiped.Bip01_L_Thigh", 1.5 * timeMul)
		end 
	end,
	[0.43] = function( self ) 
		if CLIENT and self:Clip1() < 1 then
			local ent = hg.CreateMag( self, Vector(0,15,-15) )
			ent:SetSubMaterial(1,"models/zcity/skins/walther_p22/classic/walther1")
			ent:SetSubMaterial(0,"models/zcity/skins/walther_p22/classic/walther2")
			for i = 0, ent:GetBoneCount() - 1 do
				ent:ManipulateBoneScale(i, vector_origin)
			end
			ent:ManipulateBoneScale(92, vector_full)
			ent:SetBodygroup(1,1)

			local phys = ent:GetPhysicsObject()

			if IsValid(phys) then
				phys:AddAngleVelocity(Vector(650,0,0))
			end

			self:GetWM():ManipulateBoneScale(92, vector_origin)
		end 
	end,
	[0.55] = function( self ) 
		if CLIENT and self:Clip1() < 1 then
			self:GetWM():SetBodygroup(1,0)
			self:GetWM():ManipulateBoneScale(92, vector_full)
		end
	end,
}

SWEP.AnimList = {
	["idle"] = "base_idle",
	["reload"] = "base_reload",
	["reload_empty"] = "base_reloadempty",
}

function SWEP:ModelCreated(model)
	if CLIENT and self:GetWM() then
		self:GetWM():SetSubMaterial(1,"models/zcity/skins/walther_p22/classic/walther1")
		self:GetWM():SetSubMaterial(0,"models/zcity/skins/walther_p22/classic/walther2")
	end
end


SWEP.WepSelectIcon2 = Material("vgui/wep_jack_hmcd_suppressed.png")
SWEP.IconOverride = "vgui/wep_jack_hmcd_suppressed.png"

SWEP.weaponInvCategory = 4

SWEP.weight = 0.8
SWEP.punchmul = 1.5
SWEP.punchspeed = 3
SWEP.CustomShell = "9x19"


SWEP.ScrappersSlot = "Secondary"

SWEP.LocalMuzzlePos = Vector(5.767,0.001,2.28)
SWEP.LocalMuzzleAng = Angle(0.7,-0.1,0)
SWEP.WeaponEyeAngles = Angle(0,0,0)

SWEP.Primary.ClipSize = 16
SWEP.Primary.DefaultClip = 16
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ".22 Long Rifle"
SWEP.Primary.Cone = 0
SWEP.Primary.Damage = 16

SWEP.Primary.Sound = {"arccw_uc/common/fire-22-01.ogg", 70, 90, 100}
SWEP.Primary.SoundFP = {"arccw_uc/common/fire-22-01.ogg", 70, 90, 100}

SWEP.DistSound = ""

SWEP.SupressedSound = {"arccw_uc/common/fire-22-sup-01.ogg", 65, 90, 100}
SWEP.SupressedSoundFP = {"arccw_uc/common/fire-22-sup-01.ogg", 65, 90, 100}

SWEP.Primary.SoundEmpty = {"zcitysnd/sound/weapons/makarov/handling/makarov_empty.wav", 75, 100, 105, CHAN_WEAPON, 2}
SWEP.availableAttachments = {
	barrel = {
		[1] = {"supressor4", Vector(0,0,0), {}},
		[2] = {"supressor6", Vector(0,0,0), {}},
		--[3] = {"supressor3", Vector(0,0.2,0), {}},
		["mount"] = Vector(-0.1,0.4,0.03),
	},
	underbarrel = {
		["mount"] = Vector(13, -1.4, -1),
		["mountAngle"] = Angle(0, -0.75, 90),
		["mountType"] = "picatinny_small"
	},
}

SWEP.Primary.Force = 20
SWEP.Primary.Wait = PISTOLS_WAIT
SWEP.ReloadTime = 4
SWEP.ReloadSoundes = {
	"none",
	"none",
	"pwb/weapons/fnp45/clipout.wav",
	"none",
	"pwb/weapons/fnp45/clipin.wav",
	"pwb/weapons/fnp45/sliderelease.wav",
	"none",
	"none",
	"none"
}

SWEP.PPSMuzzleEffect = "pcf_jack_mf_tpistol" -- shared in sh_effects.lua

SWEP.DeploySnd = {"homigrad/weapons/draw_pistol.mp3", 55, 100, 110}
SWEP.HolsterSnd = {"homigrad/weapons/holster_pistol.mp3", 55, 100, 110}
SWEP.HoldType = "revolver"
SWEP.ZoomPos = Vector(-3, -0.0136, 2.9594)
SWEP.RHandPos = Vector(-2, 0, 0)
SWEP.LHandPos = false
SWEP.SprayRand = {Angle(-0.00, -0.01, 0), Angle(-0.01, 0.01, 0)}
SWEP.Ergonomics = 1.5
SWEP.AnimShootMul = 2
SWEP.AnimShootHandMul = 0.1
SWEP.addSprayMul = 0.25
SWEP.Penetration = 6.5
SWEP.WorldPos = Vector(4,-1.5,-2)
SWEP.WorldAng = Angle(0, 0, 0)
SWEP.UseCustomWorldModel = true
SWEP.attPos = Vector(0, 0, 0)
SWEP.attAng = Angle(-0.1,-0.9,0)
SWEP.lengthSub = 25

SWEP.holsteredBone = "ValveBiped.Bip01_R_Thigh"
SWEP.holsteredPos = Vector(0, -2, 1)
SWEP.holsteredAng = Angle(0, 20, 30)
SWEP.shouldntDrawHolstered = true

SWEP.ShockMultiplier = 0.8
SWEP.HurtMultiplier = 1
SWEP.PainMultiplier = 1

--local to head
SWEP.RHPos = Vector(12,-4.5,3.5)
SWEP.RHAng = Angle(0,-5,90)
--local to rh
SWEP.LHPos = Vector(-1.2,-1.4,-2.8)
SWEP.LHAng = Angle(5,9,-100)

local finger1 = Angle(-65,50,-70)
local finger2 = Angle(-10,-10,-0)
local finger3 = Angle(31,1,-25)
local finger4 = Angle(-10,-5,-5)
local finger5 = Angle(0,-65,-15)
local finger6 = Angle(15,-5,-15)

function SWEP:AnimHoldPost()
	--self:BoneSet("r_finger0", vector_zero, finger6)
	--self:BoneSet("l_finger0", vector_zero, finger1)
    --self:BoneSet("l_finger02", vector_zero, finger2)
	--self:BoneSet("l_finger1", vector_zero, finger3)
	--self:BoneSet("r_finger1", vector_zero, finger4)
	--self:BoneSet("r_finger11", vector_zero, finger5)
	
end

SWEP.podkid = 1

SWEP.ShootAnimMul = 5
SWEP.SightSlideOffset = 1.2

function SWEP:DrawPost()
	local wep = self:GetWeaponEntity()
	if CLIENT and IsValid(wep) then
		self.shooanim = LerpFT(0.4,self.shooanim or 0,(self:Clip1() > 0 or self.reload) and 0 or 2.2)
		wep:ManipulateBonePosition(99,Vector(0 ,0.8*self.shooanim ,0 ),false)
		if not self.reload then
			wep:SetBodygroup(1,self:Clip1() > 0 and 0 or 1)
		end
	end
end

--RELOAD ANIMS PISTOL

-- Ультра-динамичные и кинематографичные анимации перезарядки и осмотра
SWEP.ReloadAnimLH = {
    Vector(0,0,0),
    Vector(2,-1,-3),
    Vector(-6,2,-10),
    Vector(-16,4,-30),
    Vector(-18,6,-35),
    Vector(-18,6,-35),
    Vector(-14,4,-28),
    Vector(-4,1,-8),
    "fastreload",
    Vector(2,-1,2),
    "reloadend",
    "reloadend",
}

SWEP.ReloadAnimLHAng = {
    Angle(0,0,0),
    Angle(5,-5,10),
    Angle(45,-20,15),
    Angle(75,-35,30),
    Angle(95,-50,45),
    Angle(110,-40,35),
    Angle(60,-25,15),
    Angle(10,-5,0),
    Angle(0,0,0),
    Angle(-10,5,-5),
    Angle(0,0,0),
}

SWEP.ReloadAnimRH = {
    Vector(0,0,0),
    Vector(0,0,0),
    Vector(1,0,-2),
    Vector(2,0,-4),
    Vector(1,0,-2),
    Vector(0,0,0),
    Vector(-1,0,1),
    Vector(-2,0,2),
    Vector(-4,1,-1),
    Vector(-2,0,0),
    Vector(0,0,0)
}

SWEP.ReloadAnimRHAng = {
    Angle(0,0,0),
    Angle(0,0,0),
    Angle(-5,2,-10),
    Angle(-10,5,-20),
    Angle(-5,2,-10),
    Angle(0,0,0),
    Angle(5,-2,10),
    Angle(10,-5,20),
    Angle(25,8,35),
    Angle(20,5,25),
    Angle(5,1,5),
    Angle(2,0,2),
    Angle(0,0,0)
}

SWEP.ReloadAnimWepAng = {
    Angle(0,0,0),
    Angle(8,20,25),
    Angle(-10,32,22),
    Angle(-12,35,25),
    Angle(10,30,20),
    Angle(12,34,22),
    Angle(2,32,20),
    Angle(2,30,18),
    Angle(4,32,16),
    Angle(-10,30,24),
    Angle(-10,32,22),
    Angle(-8,34,20),
    Angle(12,30,12),
    Angle(10,18,6),
    Angle(3,8,2),
    Angle(0,0,0)
}


SWEP.InspectAnimWepAng = {
    Angle(0,0,0),
    Angle(6,8,25),
    Angle(16,24,40),
    Angle(18,26,45),
    Angle(18,26,45),
    Angle(-10,-25,-25),
    Angle(2,24,-65),
    Angle(25,40,-85),
    Angle(25,40,-85),
    Angle(25,40,-85),
    Angle(5,10,-15),
    Angle(0,0,0)
}