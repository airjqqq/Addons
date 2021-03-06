local data = {
	-- Hunter

  -- [136] = { default = false, cooldown = 10, class = "HUNTER" }, -- Mend Pet
  [  1543] = { default = false, cooldown = 20, class = "HUNTER" }, -- Flare
  [  5384] = { default = false, cooldown = 30, class = "HUNTER", defensive = 0.2 }, -- Feign Death
  [109304] = { default = false, cooldown = 120, class = "HUNTER", defensive = 0.3 }, -- Exhilaration (Beast Mastery, Survival)
  [194291] = { parent = 109304 }, -- Exhilaration (Marksmanship)
  [131894] = { default = false, cooldown = 60, class = "HUNTER", offensive = true, aura = {}, talent = {} }, -- A Murder of Crows (Beast Mastery, Marksmanship)
  [206505] = { parent = 131894 }, -- A Murder of Crows (Survival)
  [186257] = { default = false, cooldown = { default = 180, [253] = 120, [255] = 144 }, class = "HUNTER", sprint = true, duration = 12 }, -- Aspect of the Cheetah
  [186265] = { default = true, cooldown = { default = 180, [255] = 144 }, class = "HUNTER", defensive = 0.9, immune = "all", duration = 8 }, -- Aspect of the Turtle
  [202914] = { default = false, cooldown = 60, class = "HUNTER", cc = true, talent = {} }, -- Spider Sting
  -- [209997] = { default = false, cooldown = 30, class = "HUNTER", defensive = 0.2  }, -- Play Dead
  [118922] = { default = false, class = "HUNTER", sprint = true, duration = 8 }, -- Posthaste

  -- Beast Mastery

  [   781] = { default = false, cooldown = 20, class = "HUNTER", specID = { 253, 254 }, blink = true }, -- Disengage
  [ 19386] = { default = false, cooldown = 45, class = "HUNTER", specID = { 253, 254 }, cc = "incapacitate", cast = 1.5, duration = 6, talent={109248,19577} }, -- Wyvern Sting
  [ 19574] = { default = false, cooldown = 75, class = "HUNTER", specID = { 253 }, offensive = 0.2, duration = 10 }, -- Bestial Wrath
  [ 19577] = { default = false, cooldown = 60, class = "HUNTER", specID = { 253 }, cc = "stun", duration = 5, aura = {19577,24394}, talent={109248,19386} }, -- Intimidation
  [109248] = { default = false, cooldown = 45, class = "HUNTER", specID = { 253, 254 }, cc = "stun", duration = 3, aura = {117526}}, -- Binding Shot
  [147362] = { default = true, cooldown = 24, class = "HUNTER", specID = { 253, 254 }, interrupt = true }, -- Counter Shot
  [193530] = { default = false, cooldown = 120, class = "HUNTER", specID = { 253 },offensive = 0.2, duration = 10 }, -- Aspect of the Wild
  -- [194386] = { default = false, cooldown = 90, class = "HUNTER", specID = { 253, 254 } }, -- Volley
  [201430] = { default = false, cooldown = 180, class = "HUNTER", specID = { 253 }, offensive = true }, -- Stampede
  [207068] = { default = false, cooldown = 60, class = "HUNTER", specID = { 253 }, offensive = true }, -- Titan's Thunder
  [208652] = { default = false, cooldown = 30, class = "HUNTER", specID = { 253 }, offensive = true }, -- Dire Beast: Hawk

  -- Marksmanship TBD

  [ 34477] = { default = false, cooldown = 30, class = "HUNTER", specID = { 254 } }, -- Misdirection
  [186387] = { default = false, cooldown = 20, class = "HUNTER", specID = { 254 }, cc = "disorient", duration = 4, aura = {224729} }, -- Bursting Shot
  [193526] = { default = false, cooldown = 140, class = "HUNTER", specID = { 254 }, duration = 15, offensive = 0.4 }, -- Trueshot
  [199483] = { default = false, cooldown = 60, class = "HUNTER", specID = { 254, 255 }, defensive = 0.1, talent = {}, duration = 60 }, -- Camouflage
  [204147] = { default = false, cooldown = 20, class = "HUNTER", specID = { 254 } }, -- Windburst
  [206817] = { default = false, cooldown = 30, class = "HUNTER", specID = { 254 } }, -- Sentinel
  -- [209789] = { default = false, cooldown = 30, class = "HUNTER", specID = { 254 }, cast = 2, cc = "incapacitate", duration = 8 }, -- Freezing Arrow
  [213691] = { default = false, cooldown = 20, class = "HUNTER", specID = { 254 }, cc = "disorient", duration = 4, talent ={} }, -- Scatter Shot

  -- Survival

  [ 53271] = { default = false, cooldown = 45, class = "HUNTER", specID = { 255 }, sprint = true, duration = 4, dispellable = true }, -- Master's Call
  [186289] = { default = false, cooldown = 96, class = "HUNTER", specID = { 255 }, offensive = 0.2, duration = 10 }, -- Aspect of the Eagle
  [187650] = { default = true, cooldown = 20, class = "HUNTER", cc = "incapacitate", aura = {3355}, duration = 8 }, -- Freezing Trap
  [203340] = { default = true, cooldown = 20, class = "HUNTER", specID = { 255 }, cc = "incapacitate", aura = {203337}, duration = 5, talent = {187650} }, -- Freezing Trap
  -- [187698] = { default = false, cooldown = 20, class = "HUNTER", specID = { 255 } }, -- Tar Trap
  [187707] = { default = false, cooldown = 15, class = "HUNTER", specID = { 255 }, interrupt = true }, -- Muzzle
  [190925] = { default = false, cooldown = 20, class = "HUNTER", specID = { 255 }, blink = true }, -- Harpoon
  -- [191241] = { default = false, cooldown = 30, class = "HUNTER", specID = { 255 } }, -- Sticky Bomb
  -- [191433] = { default = false, cooldown = 20, class = "HUNTER", specID = { 255 } }, -- Explosive Trap
  -- [194407] = { default = false, cooldown = 60, class = "HUNTER", specID = { 255 } }, -- Spitting Cobra
  [201078] = { default = false, cooldown = 90, class = "HUNTER", specID = { 255 }, offensive = true }, -- Snake Hunter
  -- [203415] = { default = false, cooldown = 45, class = "HUNTER", specID = { 255 } }, -- Fury of the Eagle
  -- [205691] = { default = false, cooldown = 120, class = "HUNTER", specID = { 255 } }, -- Dire Beast: Basilisk
  [212640] = { default = false, cooldown = 25, class = "HUNTER", specID = { 255 }, defensive= true }, -- Mending Bandage
  [ 53480] = { default = false, cooldown = 60, class = "HUNTER", specID = { 255 }, defensive= 0.2, duration = 12 }, -- Mending Bandage

}
for i,d in pairs(data) do
  LCT_SpellData[i] = d
end
