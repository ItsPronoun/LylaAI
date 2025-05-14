--[[

    This file is a part of LylaAI, a custom homunculus/mercenary AI for Ragnarok Online.

    This AI is free to distribute and to make changes. However, I encourage you to
    submit bugs and feature requests to the official GitHub repository so we can make this
    a better AI together.

]]

local Utilities = require("./AI/USER_AI/Util")

local State = { IDLE = 0, FOLLOW = 1 }

local Homunculus = {
    ID = 0,                    -- Homunculus ID
    OwnerID = 0,               -- Owner's ID
    CurrentState = State.IDLE, -- State of homunculus. Defaults to IDLE.
    DestX = 0,                 -- Destination X coordinate. Used in movement functionality.
    DestY = 0                  -- Destination Y coordinate. Used in movement functinoality.
}

--[[
    Process homunculus actions in idle state.

    @return nil
]]
local function ProcessIdleState()
    local ownerX, ownerY = Utilities.GetPosition(Homunculus.OwnerID)
    local homunX, homunY = Utilities.GetPosition(Homunculus.ID)
    -- Check distance from owner. If distance is greater than 3, set state to follow.
    -- In the future, we will adjust this to allow a custom follow distance.
    if Utilities.GetDistance(ownerX, ownerY, homunX, homunY) > 3 then
        Homunculus.CurrentState = State.FOLLOW
        return
    end
end

--[[
    Process homunculus actions in follow state.

    @return nil
]]
local function ProcessFollowState()
    local ownerX, ownerY = Utilities.GetPosition(Homunculus.OwnerID)
    local homunX, homunY = Utilities.GetPosition(Homunculus.ID)
    -- Check distance from owner. If distance is greater than 3, move the homunculus
    -- to the owner, otherwise we will set state to idle.
    if Utilities.GetDistance(ownerX, ownerY, homunX, homunY) > 3 then
        MoveToOwner(Homunculus.ID)
        return
    else
        Homunculus.CurrentState = State.IDLE
        return
    end
end

--[[
    Process the homunculus' current state

    @return nil
]]
local function ProcessState()
    if Homunculus.CurrentState == State.IDLE then
        ProcessIdleState()
    elseif Homunculus.CurrentState == State.FOLLOW then
        ProcessFollowState()
    end
end

--[[
    This function is the entry point into the homunculus AI.

    @param id (number): Actor ID of the homunculus.
    @return nil
]]
function AI(id)
    Homunculus.ID = id
    Homunculus.OwnerID = Util.GetOwner(id)

    ProcessState()
end
