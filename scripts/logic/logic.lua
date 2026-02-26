-- logic functions for the tracker

--function to check if location cluesanity is disabled
function is_cluesanity_disabled()
    return Tracker:FindObjectForCode("opt_location_cluesanity_bundle_size").AcquiredCount < 1
end

--function to check if roll is required for hourglasses
function roll_required()
    return Tracker:FindObjectForCode("opt_require_roll").CurrentStage == 1
end
function roll_not_required()
    return Tracker:FindObjectForCode("opt_require_roll").CurrentStage == 0
end

-- function to check if location is accessible based on key number
function progressive_access(key_code_param, normal_req_param, partial_req_param)
    local amount = Tracker:ProviderCountForCode(key_code_param)
    local normal_req = tonumber(normal_req_param)
    local partial_req = tonumber(partial_req_param)
    
    if amount >= normal_req then
        return AccessibilityLevel.Normal
    elseif amount >= partial_req then
        -- can access the location with glitches
        return AccessibilityLevel.SequenceBreak
    end
    return AccessibilityLevel.None
end

-- function to check access to Unseen Foe
function unseen_foe_access()
    local keys = Tracker:ProviderCountForCode("fits_key")
    local invisibility = Tracker:ProviderCountForCode("progressive_invisibility")
    
    if invisibility == 0 or keys == 0 then
        return AccessibilityLevel.SequenceBreak
    elseif keys >= 1 and invisibility >= 1 then
        return AccessibilityLevel.Normal
    end
end