--レスキューフェレット
--Rescue Ferret
--Scripted by Eerie Code
function c101001029.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(101001029,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCountLimit(1,101001029)
    e1:SetCost(c101001029.cost)
    e1:SetTarget(c101001029.target)
    e1:SetOperation(c101001029.operation)
    c:RegisterEffect(e1)
end
function c101001029.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsAbleToDeckAsCost() end
    Duel.SendtoDeck(c,nil,2,REASON_COST)
end
function c101001029.filter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101001029.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        local ft=Duel.CheckLinkedLocation(tp)
        if e:GetHandler():IsOnLinkedZone() then ft=ft+1 end
        if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
        local g=Duel.GetMatchingGroup(c101001029.filter,tp,LOCATION_DECK,0,nil,e,tp)
        return ft>0 and g:CheckWithSumEqual(Card.GetLevel,6,1,ft)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101001029.operation(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.CheckLinkedLocation(tp)
    if ft>1 and Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
    local g=Duel.GetMatchingGroup(c101001029.filter,tp,LOCATION_DECK,0,nil,e,tp)
    if ft<=0 or g:GetCount()==0 then return end
    local fid=e:GetHandler():GetFieldID()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg=g:SelectWithSumEqual(tp,Card.GetLevel,6,1,ft)
    Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP,Duel.GetExtraZone(tp))
    local tc=sg:GetFirst()
    while tc do
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e1)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetReset(RESET_EVENT+0x1fe0000)
        tc:RegisterEffect(e2)
        tc:RegisterFlagEffect(101001029,RESET_EVENT+0x1fe0000,0,1,fid)
        tc=sg:GetNext()
    end
    sg:KeepAlive()
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
    e3:SetCode(EVENT_PHASE+PHASE_END)
    e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e3:SetCountLimit(1)
    e3:SetLabel(fid)
    e3:SetLabelObject(sg)
    e3:SetCondition(c101001029.descon)
    e3:SetOperation(c101001029.desop)
    Duel.RegisterEffect(e3,tp)
end
function c101001029.desfilter(c,fid)
    return c:GetFlagEffectLabel(101001029)==fid
end
function c101001029.descon(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject()
    if not g:IsExists(c101001029.desfilter,1,nil,e:GetLabel()) then
        g:DeleteGroup()
        e:Reset()
        return false
    else return true end
end
function c101001029.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=e:GetLabelObject()
    local tg=g:Filter(c101001029.desfilter,nil,e:GetLabel())
    Duel.Destroy(tg,REASON_EFFECT)
end
