local EnemyWaveSpawner = Class(function(self, inst)
	self.inst = inst
	self.waves = "underworld"
	self.partner = nil
	self.currentwave = 0
	self.nummobs = 0
	self.delayfn = function(ent)
		if ent and ent.components.health and not ent.components.health:IsDead() then
			if ent.components.combat then
				ent.components.combat:SuggestTarget(GetPlayer())
			end
		end
	end
	if not self.partner then
		self:SearchForPartner(15)
	end
end)

function EnemyWaveSpawner:OnSave()
	local data = {}

	data.currentwave = self.currentwave
	data.nummobs = self.nummobs
	if self.partner then
		local tag = "Partner of "..tostring(self.partner)
		data.tag = tag
	end

	return data
end

function EnemyWaveSpawner:OnLoad(data)
	if data then
		self.inst:AddTag(data.tag)
		local tag = "Partner of "..tostring(self.inst)
		self.inst:DoTaskInTime(0, function()
			local partner = TheSim:FindFirstEntityWithTag(tag)
			if partner then
				self:SetPartner(parner)
			end
		end)
		self.currentwave = data.currentwave
		self.nummobs = data.nummobs
		local x, y, z = self.inst:GetPosition():Get()
		local ents = TheSim:FindEntites(x, y, z, 64, nil, {"player"})
		for k, v in pairs(ents) do
			if not v.components.follower and v.components.follower.leader == GetPlayer() then
				v:ListenForEvent("onremove", function()
					self.nummobs = self.nummobs - 1
					if self.nummobs <= 0 then
						self:WaveBeaten()
					end
				end)
			end
		end
	end
end

function EnemyWaveSpawner:SetPartner(ent)
	self.partner = ent
end

function EnemyWaveSpawner:SpawnNextWave()
	self.currentwave = self.currentwave + 1
	local pos = self.inst:GetPosition()
	local waves = require("arena/"..self.waves)
	local wave = waves[self.currentwave]
	if not wave then
		wave = waves.boss
	end
	for prefab, props in pairs(wave) do
		local num = props.num or 1
		self.nummobs = self.nummobs + num
		local delay = props.delay or 0.5
		local deltatheta = 2 * math.pi / num
		local theta = TheCamera:GetHeadingTarget() * 2 * math.pi / 360
		print("Spawning "..num.." "..prefab)

		for i = 1, num do
			self.inst:DoTaskInTime(i / 3, function()
				print("Spawning a "..prefab)
				local mob = SpawnPrefab(prefab)
				local fx = SpawnPrefab("collapse_big")
				local mobpos = pos
				mobpos.x = mobpos.x + 2 * math.cos(theta + deltatheta * i)
				mobpos.z = mobpos.z + 2 * math.sin(theta + deltatheta * i)
				mob.Transform:SetPosition(mobpos:Get())
				fx.Transform:SetPosition(mobpos:Get())
				mob:DoTaskInTime(delay, function()
					self.delayfn(mob)
					if props.delayfn then
						props.delayfn(mob)
					end
				end)
				mob:ListenForEvent("onremove", function()
					self.nummobs = self.nummobs - 1
					if self.nummobs <= 0 then
						self:WaveBeaten()
					end
				end)
			end)
		end
	end
end

function EnemyWaveSpawner:WaveBeaten()
	self.inst:DoTaskInTime(3, function() self:SpawnNextWave() end)
end

function EnemyWaveSpawner:SearchForPartner(dist)
	local partner = FindEntity(self.inst, dist, function(guy)
		return guy.prefab == self.inst.prefab and guy.components.enemywavespawner
	end)
	if partner then
		self:SetPartner(partner)
	elseif dist <= 150 then
		self:SearchForPartner(dist + 15)
	end
end

return EnemyWaveSpawner