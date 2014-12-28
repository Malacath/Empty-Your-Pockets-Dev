--H.P.Lovecraft's "The rats in the walls"... By Lawrence Caustic Sorrow
--The book spawns 10/20 ghost rats. Each ghost rat follows the player and attack everything is near him.
--Each ghost rat disappear after 20/30 seconds.

local assets=
{
	Asset("ANIM", "anim/books.zip"),
	
}

local function onfinished(inst)
    inst:Remove()
end

function rats(inst, reader)
    local pt = Vector3(reader.Transform:GetWorldPosition())

    local numrats = 10

    reader.components.sanity:DoDelta(-TUNING.SANITY_HUGE)

    reader:StartThread(function()
        for k = 1, numrats do
        
            local theta = math.random() * 2 * PI
            local radius = math.random(3, 8)

            local result_offset = FindValidPositionByFan(theta, radius, 12, function(offset)
                local x,y,z = (pt + offset):Get()
                local ents = TheSim:FindEntities(x,y,z , 1)
                return not next(ents) 
            end)

            if result_offset then
                local ghostrats = SpawnPrefab("ghostrat")
				
				ghostrats.Transform:SetPosition((pt + result_offset):Get())
				
				if math.random() > .5 then
				local ghostrats2 = SpawnPrefab("ghostrat")
				ghostrats2.Transform:SetPosition((pt + result_offset):Get())
				end

                GetPlayer().components.playercontroller:ShakeCamera(reader, "FULL", 0.2, 0.02, .25, 40)

                local fx = SpawnPrefab("statue_transition_2")
                local pos = pt + result_offset
                fx.Transform:SetPosition(pos.x, pos.y, pos.z)
                ghostrats.sg:GoToState("look")
            end

            Sleep(.33)
        end
    end)
    return true    

end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    
    anim:SetBank("books")
    anim:SetBuild("books")
    anim:PlayAnimation("idle")
    
		inst:AddComponent("inspectable")
        inst:AddComponent("book")
        inst.components.book.onread = rats
        
        inst:AddComponent("inventoryitem")

        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses( 5 )
        inst.components.finiteuses:SetUses( 5 )
        inst.components.finiteuses:SetOnFinished( onfinished )

        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)
    
    return inst
end

return Prefab( "common/inventory/bookrats", fn, assets) 
