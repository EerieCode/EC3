--Created and scripted by Eerie Code
--The Phantom Knights of Stained Cleaver
function c216666039.initial_effect(c)
    c:EnableReviveLimit()
    --xyz summon
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_SPSUMMON_PROC)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetRange(LOCATION_EXTRA)
    e1:SetCondition(c216666039.xyzcon)
    e1:SetOperation(c216666039.xyzop)
    e1:SetValue(SUMMON_TYPE_XYZ)
    c:RegisterEffect(e1)
    --spsummon
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(62709239,1))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_DESTROYED)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
    e2:SetCondition(c216666039.spcon)
    e2:SetTarget(c216666039.sptg)
    e2:SetOperation(c216666039.spop)
    c:RegisterEffect(e2)
    --attack twice
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE)
    e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCode(EFFECT_EXTRA_ATTACK)
    e4:SetValue(1)
    c:RegisterEffect(e4)
    local e5=Effect.CreateEffect(c)
    e5:SetType(EFFECT_TYPE_SINGLE)
    e5:SetRange(LOCATION_MZONE)
    e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e5:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
    e5:SetCondition(c216666039.dircon)
    c:RegisterEffect(e5)
    local e6=e5:Clone()
    e6:SetCode(EFFECT_CANNOT_ATTACK)
    e6:SetCondition(c216666039.atkcon2)
    c:RegisterEffect(e6)
    --Destroy
    local e7=Effect.CreateEffect(c)
    e7:SetCategory(CATEGORY_DESTROY)
    e7:SetType(EFFECT_TYPE_QUICK_O)
    e7:SetCode(EVENT_FREE_CHAIN)
    e7:SetRange(LOCATION_MZONE)
    e7:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e7:SetCountLimit(1,216666039+EFFECT_COUNT_CODE_SINGLE)
    e7:SetCost(c216666039.descost)
    e7:SetTarget(c216666039.destg)
    e7:SetOperation(c216666039.desop)
    c:RegisterEffect(e7)
    --Banish
    local e8=e7:Clone()
    e8:SetTarget(c216666039.rmtg)
    e8:SetOperation(c216666039.rmop)
    c:RegisterEffect(e8)
end

c216666039.xyz_count=3
function c216666039.ovfilter(c,tp,xyzc)
    return c:IsFaceup() and c:IsCode(62709239) and c:IsCanBeXyzMaterial(xyzc) and c:CheckRemoveOverlayCard(tp,1,REASON_COST)
end
function c216666039.ovfilter2(c,tp,xyzc)
    return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetLevel()==4 and c:IsAttribute(ATTRIBUTE_DARK) and c:IsCanBeXyzMaterial(xyzc)
end
function c216666039.xyzcon(e,c,og)
    if c==nil then return true end
    local tp=c:GetControler()
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local ct=-ft
    if 3<=ct then return false end
    if ct<2 and not og and Duel.IsExistingMatchingCard(c216666039.ovfilter,tp,LOCATION_MZONE,0,1,nil,tp,c) then
        return true
    end
    return Duel.CheckXyzMaterial(c,c216666039.ovfilter2,3,3,3,og)
end
function c216666039.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og)
    if og then
        c:SetMaterial(og)
        Duel.Overlay(c,og)
    else
        local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
        local ct=-ft
        local b1=Duel.CheckXyzMaterial(c,c216666039.ovfilter2,3,3,3,og)
        local b2=ct<1 and Duel.IsExistingMatchingCard(c216666039.ovfilter,tp,LOCATION_MZONE,0,1,nil,tp,c)
        if b2 and (not b1 or Duel.SelectYesNo(tp,aux.Stringid(216666039,0))) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
            local mg=Duel.SelectMatchingCard(tp,c216666039.ovfilter,tp,LOCATION_MZONE,0,1,1,nil,tp,c)
            mg:GetFirst():RemoveOverlayCard(tp,1,1,REASON_COST)
            local mg2=mg:GetFirst():GetOverlayGroup()
            if mg2:GetCount()~=0 then
                Duel.Overlay(c,mg2)
            end
            c:SetMaterial(mg)
            Duel.Overlay(c,mg)
            c:RegisterFlagEffect(216666039,RESET_EVENT+0xfe0000+RESET_PHASE+PHASE_END,0,1)
        else
            local mg=Duel.SelectXyzMaterial(tp,c,c216666039.ovfilter2,3,3,3)
            c:SetMaterial(mg)
            Duel.Overlay(c,mg)
        end
    end
end

function c216666039.spcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsPreviousLocation(LOCATION_MZONE) and bit.band(c:GetSummonType(),SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c216666039.spfilter1(c,e,tp)
    return c:GetLevel()>0 and c:IsSetCard(0x10db) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
        and Duel.IsExistingTarget(c216666039.spfilter2,tp,LOCATION_GRAVE,0,2,c,c:GetLevel(),e,tp)
end
function c216666039.spfilter2(c,lv,e,tp)
    return c:GetLevel()==lv and c:IsSetCard(0x10db) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c216666039.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>2
        and Duel.IsExistingTarget(c216666039.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g1=Duel.SelectTarget(tp,c216666039.spfilter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    local tc1=g1:GetFirst()
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g2=Duel.SelectTarget(tp,c216666039.spfilter2,tp,LOCATION_GRAVE,0,2,2,tc1,tc1:GetLevel(),e,tp)
    g1:Merge(g2)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,3,0,0)
end
function c216666039.spop(e,tp,eg,ep,ev,re,r,rp)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local g=tg:Filter(Card.IsRelateToEffect,nil,e)
    if ft>0 and g:GetCount()<=ft then
        local tc=g:GetFirst()
        while tc do
            Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
            local e1=Effect.CreateEffect(e:GetHandler())
            e1:SetType(EFFECT_TYPE_SINGLE)
            e1:SetCode(EFFECT_UPDATE_LEVEL)
            e1:SetReset(RESET_EVENT+0x1fe0000)
            e1:SetValue(2)
            tc:RegisterEffect(e1)
            tc=g:GetNext()
        end
        Duel.SpecialSummonComplete()
    end
    local e2=Effect.CreateEffect(e:GetHandler())
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
    e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e2:SetTargetRange(1,0)
    e2:SetTarget(c216666039.splimit)
    e2:SetReset(RESET_PHASE+PHASE_END)
    Duel.RegisterEffect(e2,tp)
end
function c216666039.splimit(e,c)
    return not c:IsAttribute(ATTRIBUTE_DARK)
end

function c216666039.dircon(e)
    return e:GetHandler():GetAttackAnnouncedCount()>0
end
function c216666039.atkcon2(e)
    return e:GetHandler():IsDirectAttacked()
end

function c216666039.descost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
    e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c216666039.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return false end
    if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,nil)
        and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g1=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,1,nil)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g2=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
    g1:Merge(g2)
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,2,0,0)
end
function c216666039.desop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
    local tg=g:Filter(Card.IsRelateToEffect,nil,e)
    if tg:GetCount()>0 then
        Duel.Destroy(tg,REASON_EFFECT)
    end
end

function c216666039.rmfil(c)
    return c:IsFaceup() and c:IsSetCard(0x10db) and not c:IsCode(216666039)
end
function c216666039.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c216666039.rmfil(chkc) end
    if chk==0 then return e:GetHandler():GetFlagEffect(216666039)==0 and Duel.IsExistingTarget(c216666039.rmfil,tp,LOCATION_MZONE,0,1,nil) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
    Duel.SelectTarget(tp,c216666039.rmfil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c216666039.rmop(e,tp,eg,ep,ev,re,r,rp)
    local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetDescription(aux.Stringid(7572887,0))
        e1:SetCategory(CATEGORY_REMOVE)
        e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
        e1:SetCode(EVENT_BATTLED)
        e1:SetTarget(c216666039.rmtg2)
        e1:SetOperation(c216666039.rmop2)
        e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
        tc:RegisterEffect(e1)
    end
end
function c216666039.rmtg2(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local a=Duel.GetAttacker()
    local t=Duel.GetAttackTarget()
    if chk==0 then
        return (t==c and a:IsAbleToRemove())
            or (a==c and t~=nil and t:IsAbleToRemove())
    end
    local g=Group.CreateGroup()
    if a:IsRelateToBattle() then g:AddCard(a) end
    if t~=nil and t:IsRelateToBattle() then g:AddCard(t) end
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c216666039.rmop2(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local d=Duel.GetAttackTarget()
    local g=Group.FromCards(a,d)
    local rg=g:Filter(Card.IsRelateToBattle,nil)
    Duel.Remove(rg,POS_FACEUP,REASON_EFFECT)
end
