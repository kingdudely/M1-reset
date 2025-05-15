# CFrame is recommended

Edit the settings in the code if you want to change the side dashes.

# Get side dash animations
If you want to get the side dash animations in your game:
1. Go to the ROBLOX console by either typing `/console` in chat, or just click on the `F9` key.
2. Now, side dash and then execute this immediately (you have to run this for both left and right side dashes):
```luau
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Animator = Character:FindFirstChildWhichIsA("Animator", true)

for _, track in Animator:GetPlayingAnimationTracks() do
    print(track.Animation.AnimationId)
end
```
3. You will see something like `rbxassetid://...` in the console. This is an **Animation ID**. Copy the numbers. To check if it is the side dash animation, just run this code and replace the `NUMBER` in `local id = NUMBER` with your number.
```luau
local id = NUMBER

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Animator = Character:FindFirstChildWhichIsA("Animator", true)

local function play(id, speed)
    id = tostring(id)
    
    local Animation = Instance.new("Animation")
    Animation.AnimationId = id:match("rbxassetid://") and id or `rbxassetid://{id}`

    local loaded = Animator:LoadAnimation(Animation)

    loaded:Play(0.1, 1, speed or 1)

    return loaded
end

play(id)
```
5. Now, run
```luau
setclipboard(game.GameId)
```
You might need to wait a bit before it copies to your clipboard. This is your **Game ID**.

5. Now, go into the M1 reset code and edit the thing in between the brackets of
```luau
local animations = {
    ...
}
```
The format is:
```luau
local animations = {
    [GameID] = {
        left = LeftSideDashAnimationId,
        right = RightSideDashAnimationId
    },

    ...
}
```
And you're done!
