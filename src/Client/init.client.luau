--!nocheck

const children = script:GetChildren()

for _, child in children do
	if not child:IsA("ModuleScript") then
		continue
	end

	require(child)
end
