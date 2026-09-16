const CollectionService = game:GetService("CollectionService")

const Constants = require(script.Constants)
const Mirage = require(script.Mirage)
const MirageController = {}
const mt = {}
mt.__index = mt

const private = {}

local function _handleInstanceAdded(self: MirageController, instance: Instance)
	if not instance:IsA("Model") then
		return
	end

	const success, result = pcall(function()
		private[self].Mirages[instance] = Mirage.new(instance)
		print(`Created a Mirage instance for {instance.Name}`)
	end)

	if not success then
		return warn(`Error creating a Mirage instance for {instance.Name}: {result}`)
	end
end

local function _handleInstanceRemoved(self: MirageController, instance: Instance)
	if not instance:IsA("Model") then
		return
	end

	const success, result = pcall(function(...)
		const mirage = private[self].Mirages[instance]
		if not mirage then
			warn(`Tried to destroy a Mirage instance for {instance.Name}, but it does not exists!`)
			return
		end

		mirage:Destroy()
		private[self].Mirages[instance] = nil

		print(`Destroyed a Mirage instance for {instance.Name}`)
	end)

	if not success then
		return warn(`Error destroying a Mirage instance for {instance.Name}: {result}`)
	end
end

function MirageController.new()
	const self = setmetatable({}, mt)

	private[self] = {
		Mirages = {},
	}

	for _, instance in CollectionService:GetTagged(Constants.Mirage.TAG) do
		_handleInstanceAdded(self, instance)
	end

	CollectionService:GetInstanceAddedSignal(Constants.Mirage.TAG):Connect(function(instance)
		_handleInstanceAdded(self, instance)
	end)

	CollectionService:GetInstanceRemovedSignal(Constants.Mirage.TAG):Connect(function(instance)
		_handleInstanceRemoved(self, instance)
	end)

	return self
end

type MirageController = typeof(MirageController.new(...))

return MirageController.new()
