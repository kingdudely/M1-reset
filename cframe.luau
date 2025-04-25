pcall(function()
    getgenv().fakeDash:Disconnect()
    getgenv().fakeDash = nil
end)

local settings = {
    key = "e",
    distance = 30,
    duration = 0.5,

    animations = {
        left = "10480796021",
        right = "10480793962",
    },

    easing = {
        Enum.EasingStyle.Cubic,
        Enum.EasingDirection.Out,
    },
}

local CurrentCamera = workspace.CurrentCamera

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChildWhichIsA("Humanoid")
local HumanoidRootPart = Humanoid.RootPart
local Animator = Humanoid:FindFirstChildWhichIsA("Animator")

local function play(id, speed)
    local Animation = Instance.new("Animation")
    Animation.AnimationId = id:match("rbxassetid://") and id or `rbxassetid://{id}`

    local loaded = Animator:LoadAnimation(Animation)

    loaded:Play(0.1, 1, speed or 1)

    return loaded
end

getgenv().fakeDash = UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed then
        if input.KeyCode == Enum.KeyCode[settings.key:upper()] then
            local MoveDirection = Humanoid.MoveDirection
            local CameraCFrame = CurrentCamera.CFrame
            local sideMovement = MoveDirection:Dot(CameraCFrame.RightVector)

            if math.abs(sideMovement) >= 0.5 then
                local direction = math.sign(sideMovement)
                play(direction == -1 and settings.animations.left or settings.animations.right)

                local ticked, elapsed = tick(), 0
                local lastEasingValue = 0

                while elapsed < settings.duration do
                    elapsed = tick() - ticked
                    CameraCFrame = CurrentCamera.CFrame

                    local alpha = math.clamp(elapsed / settings.duration, 0, 1)
                    local easingValue = TweenService:GetValue(alpha, unpack(settings.easing))

                    local deltaEasing = easingValue - lastEasingValue
                    lastEasingValue = easingValue

                    local dashDirection = CameraCFrame.RightVector * direction
                    local distance = settings.distance * deltaEasing

                    local LookVector = CameraCFrame.LookVector
                    LookVector = Vector3.new(LookVector.X, 0, LookVector.Z)

                    local position = HumanoidRootPart.Position + dashDirection * distance
                    HumanoidRootPart.CFrame = CFrame.lookAt(position, position + LookVector)

                    task.wait()
                end
            end
        end
    end
end)
