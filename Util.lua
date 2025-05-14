--[[

    This file is a part of LylaAI, a custom homunculus/mercenary AI for Ragnarok Online.

    This AI is free to distribute and to make changes. However, I encourage you to
    submit bugs and feature requests to the official GitHub repository so we can make this
    a better AI together.

]]

Util = {}

ClientVar = {
    V_OWNER = 0,
    V_POSITION = 1,
    V_TYPE = 2,
    V_MOTION = 3,
    V_ATTACKRANGE = 4,
    V_TARGET = 5,
    V_SKILLATTACKRANGE = 6,
    V_HOMUNTYPE = 7,
    V_HP = 8,
    V_SP = 9,
    V_MAXHP = 10,
    V_MAXSP = 11
}

Motion = {
    STAND = 0,
    MOVE = 1,
    ATTACK = 2,
    DEAD = 3,
    SIT = 6,
    ATTACK2 = 9
}

--[[
        Calculate the birds-eye distance between two coordinates.

        @param originX (number): Origin X coordinate
        @param originY (number): Origin Y coordinate
        @param destX (number): Destination X coordinate
        @param destY (number): Destination Y coordinate
        @return number: Return the birds-eye distance between the two points.
]]
function Util.GetDistance(originX, originY, destX, destY)
    return math.sqrt((destX - originX) ^ 2 + (destY - originY) ^ 2)
end

--[[
        Get the owner of the homunculus/mercenary with the given actor ID.

        @param id (number): In-game actor ID.
        @return number: Return the actor ID of the owner.
]]
function Util.GetOwner(id)
    return GetV(ClientVar.V_OWNER, id)
end

--[[
        Get the position of an actor.

        @param id (number): In-game actor ID.
        @return number, number: Returns the x, y coordinate of the actor.
]]
function Util.GetPosition(id)
    return GetV(ClientVar.V_POSITION, id)
end

--[[
        Get whether or not an actor is dead.

        @param id (number): In-game actor ID.
        @return boolean: Returns true if the given actor is dead.
]]
function Util.IsDead(id)
    return GetV(ClientVar.V_MOTION, id) == Motion.DEAD
end

--[[
        Get the target of the specified actor.

        @param id (number): In-game actor ID.
        @return boolean: Returns id of the target.
]]
function Util.GetTarget(id)
    return GetV(ClientVar.V_TARGET, id)
end

--[[
        Get whether or not an actor is moving (walking).

        @param id (number): In-game actor ID.
        @return boolean: Returns true if the given actor is moving.
]]
function Util.IsMoving(id)
    return GetV(ClientVar.V_MOTION, id) == 1
end

return Util
