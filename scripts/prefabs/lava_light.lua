local prefabs = {
	"lavalight",
}

local function SpawnFire(inst)
	print("SpawnFire")
	local pos = inst:GetPosition()
	local fire = SpawnPrefab("lavalight")
	fire.Transform:SetPosition(pos:Get())
	fire.AnimState:SetScale(math.random(), math.random(), 1)
    inst:DoTaskInTime(math.random()*117 + 3, SpawnFire)
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local light = inst.entity:AddLight()

	--light:SetRadius(4.2)
	light:SetRadius(4.2 + math.random() * 0.5)
    light:SetFalloff(1)
    light:SetIntensity(.75)
    light:SetColour(255/255, 102/255, 0/255)

    --inst:DoTaskInTime(math.random()*15, SpawnFire)

    return inst
end

return Prefab("common/lava_light", fn, {}, prefabs)