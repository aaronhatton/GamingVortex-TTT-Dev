
if SERVER then

   AddCSLuaFile( "shared.lua" )
   
end

SWEP.HoldType           = "ar2"

if CLIENT then
   
   SWEP.PrintName          = "Silenced Sniper"           
   SWEP.Author             = "Draks & Goupyl"
   SWEP.Slot               = 6
   SWEP.IconLetter         = "w"
   SWEP.Icon = "VGUI/ttt/icon_g3sg1"   
end


SWEP.Base               = "weapon_tttbase"
SWEP.Spawnable = false
SWEP.AdminSpawnable = true

SWEP.Kind = WEAPON_EQUIP1

SWEP.Primary.Delay          = 0.9
SWEP.Primary.Recoil         = 4
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Damage = 48
SWEP.Primary.Cone = 0.006
SWEP.Primary.ClipSize = 16
SWEP.Primary.ClipMax = 20 -- keep mirrored to ammo
SWEP.Primary.DefaultClip = 20
SWEP.AutoSpawnable      = false
SWEP.AmmoEnt = "item_ammo_357_ttt"
SWEP.ViewModel = "models/weapons/v_snip_g3sg1.mdl"
SWEP.WorldModel = "models/weapons/w_snip_g3sg1.mdl"

SWEP.Primary.Sound = Sound ("Weapon_M4A1.Silenced")
--SWEP.Primary.Sound            = Sound( "Weapon_M4A1.Single" )

--SWEP.IronSightsPos        = Vector( 5, 0, 1 )
SWEP.IronSightsPos = Vector(0, 0, -15)
SWEP.CanBuy = { ROLE_TRAITOR }
SWEP.LimitedStock = true

SWEP.EquipMenuData = {
   type = "Weapon",
   model="models/weapons/w_snip_g3sg1.mdl",
   desc = "Sniper Silenced."
};
SWEP.AllowDrop = true
SWEP.IsSilent = true

SWEP.PrimaryAnim = ACT_VM_PRIMARYATTACK_SILENCED
SWEP.ReloadAnim = ACT_VM_RELOAD_SILENCED

function SWEP:Deploy()
   self.Weapon:SendWeaponAnim(ACT_VM_DRAW_SILENCED)
   return true
end

-- We were bought as special equipment, and we have an extra to give
function SWEP:WasBought(buyer)
   if IsValid(buyer) then -- probably already self.Owner
      buyer:GiveAmmo( 10, "357" )
   end
end
function SWEP:SetZoom(state)
    if CLIENT then 
       return
    else
       if state then
          self.Owner:SetFOV(20, 0.3)
       else
          self.Owner:SetFOV(0, 0.2)
       end
    end
end

-- Add some zoom to ironsights for this gun
function SWEP:SecondaryAttack()
    if not self.IronSightsPos then return end
    if self.Weapon:GetNextSecondaryFire() > CurTime() then return end
    
    bIronsights = not self:GetIronsights()
    
    self:SetIronsights( bIronsights )
    
    if SERVER then
        self:SetZoom(bIronsights)
    end
    
    self.Weapon:SetNextSecondaryFire( CurTime() + 0.3)
end

function SWEP:PreDrop()
    self:SetZoom(false)
    self:SetIronsights(false)
    return self.BaseClass.PreDrop(self)
end

function SWEP:Reload()
    self.Weapon:DefaultReload( ACT_VM_RELOAD );
    self:SetIronsights( false )
    self:SetZoom(false)
end


function SWEP:Holster()
    self:SetIronsights(false)
    self:SetZoom(false)
    return true
end

if CLIENT then
   function SWEP:DrawHUD()
      if self:GetIronsights() then
         surface.SetDrawColor( 0, 0, 0, 255 )
         
         local x = ScrW() / 2.0
         local y = ScrH() / 2.0

         local gap = 140
         local length = 320
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )

         gap = 42
         length = 120
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )

         surface.SetDrawColor(255, 255, 255, 255)

         gap = 2
         length = 10
         surface.DrawLine( x - length, y, x - gap, y )
         surface.DrawLine( x + length, y, x + gap, y )
         surface.DrawLine( x, y - length, x, y - gap )
         surface.DrawLine( x, y + length, x, y + gap )
      else
         return self.BaseClass.DrawHUD(self)
      end
   end

end
   resource.AddFile("materials/VGUI/ttt/icon_g3sg1.vmt")
   resource.AddFile("materials/VGUI/ttt/icon_g3sg1.vtf")