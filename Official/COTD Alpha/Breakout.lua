--絶縁の落とし穴
--Breakout Trap Hole
--Scripted by Eerie Code
function c101001075.initial_effect(c)
    --Activate(summon)
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_SPSUMMON_SUCCESS)
    e1:SetTarget(c101001075.target)
    e1:SetOperation(c101001075.activate)
    c:RegisterEffect(e1)
end
function c101001075.cfilter(c,e)
    return c:IsFaceup() and c:IsType(TYPE_LINK) and bit.band(c:GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c101001075.filter(c)
    return not c:IsOnLinkedZone()
end
function c101001075.target(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(c101001075.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    if chk==0 then return eg:IsExists(c101001075.cfilter,1,nil) and g:GetCount()>0 end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c101001075.activate(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c101001075.filter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
    if g:GetCount()>0 then
        Duel.Destroy(g,REASON_EFFECT)
    end
end
