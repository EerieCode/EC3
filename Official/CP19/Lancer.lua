--オッドアイズ・ランサー・ドラゴン
--Odd-Eyes Lancer Dragon
--Scripted by Eerie Code
function c100217001.initial_effect(c)
    --spsummon
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(100217001,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_DESTROYED)
    e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(c100217001.spcon)
    e1:SetCost(c100217001.spcost)
    e1:SetTarget(c100217001.sptg)
    e1:SetOperation(c100217001.spop)
    c:RegisterEffect(e1)
    --actlimit
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetCode(EFFECT_CANNOT_ACTIVATE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetTargetRange(0,1)
    e2:SetValue(c100217001.aclimit)
    e2:SetCondition(c100217001.actcon)
    c:RegisterEffect(e2)
end
function c100217001.cfilter(c)
    return c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:IsType(TYPE_PENDULUM)
        and c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
end
function c100217001.spcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(c100217001.cfilter,1,nil,tp)
end
function c100217001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckReleaseGroup(tp,nil,1,nil) end
    local sg=Duel.SelectReleaseGroup(tp,nil,1,1,nil)
    Duel.Release(sg,REASON_COST)
end
function c100217001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c100217001.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
    end
end
function c100217001.aclimit(e,re,tp)
    return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c100217001.actcon(e)
    return Duel.GetAttacker()==e:GetHandler()
end
