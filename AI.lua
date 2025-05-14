--[[

    This file is a part of LylaAI, a custom homunculus/mercenary AI for Ragnarok Online.

    This AI is free to distribute and to make changes. However, I encourage you to
    submit bugs and feature requests to the official GitHub repository so we can make this
    a better AI together.

]]

local Utilities = require("./AI/USER_AI/Util")

local State = { IDLE = 0, FOLLOW = 1, CHASE = 2, ATTACK = 3 }

local Homunculus = {
    ID = 0,                    -- Homunculus ID
    OwnerID = 0,               -- Owner's ID
    CurrentState = State.IDLE, -- State of homunculus. Defaults to IDLE.
    Target = 0,                -- Current homunculus target
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
    Process homunculus actions in chase state.

    @return nil
]]
local function ProcessChaseState()
    if Homunculus.Target ~= 0 then
        if not Util.IsDead(Homunculus.Target) then
            local targetX, targetY = Util.GetPosition(Homunculus.Target)
            local homunX, homunY = Util.GetPosition(Homunculus.ID)
            if Util.GetDistance(targetX, targetY, homunX, homunY) > 1 then
                if not Util.IsMoving(Homunculus.ID) then
                    Move(Homunculus.ID, targetX, targetY)
                end
            else
                Homunculus.CurrentState = State.ATTACK
            end
        else
            Homunculus.Target = 0
            Homunculus.CurrentState = State.IDLE
        end
    else
        Homunculus.CurrentState = State.IDLE
    end
end

--[[
    Process homunculus actions in attack state.

    @return nil
]]
local function ProcessAttackState()
    if Homunculus.Target ~= 0 then
        if not Util.IsDead(Homunculus.Target) then
            local targetX, targetY = Util.GetPosition(Homunculus.Target)
            local homunX, homunY = Util.GetPosition(Homunculus.ID)
            if Util.GetDistance(targetX, targetY, homunX, homunY) <= 1 then
                Attack(Homunculus.ID, Homunculus.Target)
            else
                Homunculus.CurrentState = State.CHASE
            end
        else
            Homunculus.Target = 0
            Homunculus.CurrentState = State.IDLE
        end
    else
        Homunculus.CurrentState = State.IDLE
    end
end

--[[
    Looks for a new target.

    @return nil
]]
local function GetNextTarget()
    -- Before we process state, lets ensure the homunculus or owner do not need rescued.
    local nearbyActors = GetActors()
    for _, actor in ipairs(nearbyActors) do
        if actor ~= Homunculus.ID and actor ~= Homunculus.OwnerID then
            if IsMonster(actor) and not Utilities.IsDead(actor) then
                if Util.GetTarget(actor) == Homunculus.OwnerID then
                    local actorX, actorY = Util.GetPosition(actor)
                    local homunX, homunY = Util.GetPosition(Homunculus.ID)

                    Homunculus.Target = actor
                    if Util.GetDistance(actorX, actorY, homunX, homunY) > 1 then
                        Homunculus.CurrentState = State.CHASE
                    else
                        Homunculus.CurrentState = State.ATTACK
                    end
                    return
                end
            end
        end
    end

    for _, actor in ipairs(nearbyActors) do
        if actor ~= Homunculus.ID and actor ~= Homunculus.OwnerID then
            if IsMonster(actor) and not Utilities.IsDead(actor) then
                if Util.GetTarget(actor) == Homunculus.ID then
                    local actorX, actorY = Util.GetPosition(actor)
                    local homunX, homunY = Util.GetPosition(Homunculus.ID)

                    Homunculus.Target = actor
                    if Util.GetDistance(actorX, actorY, homunX, homunY) > 1 then
                        Homunculus.CurrentState = State.CHASE
                    else
                        Homunculus.CurrentState = State.ATTACK
                    end
                    return
                end
            end
        end
    end
end

--[[
    Process the homunculus' current state

    @return nil
]]
local function ProcessState()
    -- Look for potential targets
    GetNextTarget()

    if Homunculus.CurrentState == State.IDLE then
        ProcessIdleState()
    elseif Homunculus.CurrentState == State.FOLLOW then
        ProcessFollowState()
    elseif Homunculus.CurrentState == State.CHASE then
        ProcessChaseState()
    elseif Homunculus.CurrentState == State.ATTACK then
        ProcessAttackState()
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
