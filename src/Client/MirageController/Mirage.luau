const HttpService = game:GetService("HttpService")
const Players = game:GetService("Players")
const RunService = game:GetService("RunService")

const Constants = require(script.Parent.Constants)

const Mirage = {}
const mt = {}
mt.__index = mt

const private = {}

local function _onUpdate(self: Mirage): ()
	const character = Players.LocalPlayer.Character
	if not character or not character.PrimaryPart then
		return
	end

	const minDistance = self:GetMinMirageDistance()
	const maxDistance = self:GetMaxMirageDistance()
	const minTransparency = self:GetMinTransparency()
	const maxTransparency = self:GetMaxTransparency()

	--- Distance between the player's character and the mirage's `BasePart`
	const distance: number = (character.PrimaryPart.Position - private[self].PrimaryPart.Position).Magnitude

	-- Calculate transparency based on distance
	const alpha = math.clamp((distance - minDistance) / (maxDistance - minDistance), 0, 1)
	const transparency = math.lerp(minTransparency, maxTransparency, alpha)

	for _, instance in private[self].Descendants do
		if not instance:IsA("BasePart") then
			continue
		end

		instance.Transparency = transparency
	end
end

local function _getPrimaryPart(model: Model): BasePart
	const primaryPart = model.PrimaryPart
	assert(primaryPart, "A mirage model must have a primary part")
	return primaryPart
end

function Mirage.new(model: Model)
	const self = setmetatable({}, mt)

	private[self] = {
		Model = model,
		PrimaryPart = _getPrimaryPart(model),
		Descendants = model:GetDescendants(),
		RunServiceBind = `Mirage_{model.Name}_{HttpService:GenerateGUID(false)}`,
	}

	RunService:BindToRenderStep(private[self].RunServiceBind, Enum.RenderPriority.Character.Value, function()
		_onUpdate(self)
	end)

	return self
end

function mt.GetMinMirageDistance(self: Mirage): number
	const attribute = private[self].Model:GetAttribute(Constants.MIN_MIRAGE_DISTANCE_ATTRIBUTE)
	return typeof(attribute) == "number" and attribute or 0
end

function mt.GetMaxMirageDistance(self: Mirage): number
	const attribute = private[self].Model:GetAttribute(Constants.MAX_MIRAGE_DISTANCE_ATTRIBUTE)
	return typeof(attribute) == "number" and attribute or 100
end

function mt.GetMinTransparency(self: Mirage): number
	const attribute = private[self].Model:GetAttribute(Constants.MIN_TRANSPARENCY_ATTRIBUTE)
	return typeof(attribute) == "number" and attribute or 0
end

function mt.GetMaxTransparency(self: Mirage): number
	const attribute = private[self].Model:GetAttribute(Constants.MAX_TRANSPARENCY_ATTRIBUTE)
	return typeof(attribute) == "number" and attribute or 1
end

function mt.Destroy(self: Mirage): ()
	RunService:UnbindFromRenderStep(private[self].RunServiceBind)
	table.clear(self :: any)
	setmetatable(self :: any, nil)
end

export type Mirage = typeof(Mirage.new(...))

return Mirage
