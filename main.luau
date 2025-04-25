pcall(function()
    -- print(getgenv().fakeDash)
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

local GameSettings = UserSettings().GameSettings
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
            local RightVector = CurrentCamera.CFrame.RightVector
            local sideMovement = MoveDirection:Dot(RightVector)

            if math.abs(sideMovement) >= 0.5 then
                local RotationType = GameSettings.RotationType
                GameSettings.RotationType = Enum.RotationType.CameraRelative

                local direction = math.sign(sideMovement)
                play(direction == -1 and settings.animations.left or settings.animations.right) -- -1 = left, 1 = right

                local ticked, elapsed = tick(), 0
                local lastEasingValue = 0

                while elapsed < settings.duration do
                    elapsed = tick() - ticked
                    local alpha = math.clamp(elapsed / settings.duration, 0, 1)
                    local easingValue = TweenService:GetValue(alpha, unpack(settings.easing))

                    local deltaEasing = easingValue - lastEasingValue
                    lastEasingValue = easingValue

                    local RightVector = CurrentCamera.CFrame.RightVector
                    local directionVector = RightVector * direction

                    local frameDistance = settings.distance * deltaEasing

                    HumanoidRootPart.CFrame += directionVector * frameDistance

                    task.wait()
                end


                GameSettings.RotationType = RotationType
            end
        end
    end
end)
