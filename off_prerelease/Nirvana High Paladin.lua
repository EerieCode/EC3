--Scripted by Eerie Code
--Nirvana High Paladin
function c7146.initial_effect(c)
    c:EnableReviveLimit()
    --pendulum summon
    aux.EnablePendulumAttribute(c,false)
    --Battle indestructable
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetRange(LOCATION_PZONE)
    e1:SetTargetRange(LOCATION_MZONE,0)
    e1:SetTarget(c7146.indtg)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    --avoid battle damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_FIELD)
    e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
    e2:SetRange(LOCATION_PZONE)
    e2:SetTargetRange(LOCATION_MZONE,0)
    e2:SetTarget(c7146.indtg)
    e2:SetValue(1)
    c:RegisterEffect(e2)
    --Reduce ATK
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(7146,0))
    e3:SetCategory(CATEGORY_ATKCHANGE)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_DAMAGE_STEP_END)
    e3:SetCondition(c7146.atkcon)
    e3:SetTarget(c7146.atktg)
    e3:SetOperation(c7146.atkop)
    c:RegisterEffect(e3)
    --Synchro Procedure
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetCode(EFFECT_SPSUMMON_PROC)
    e4:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
    e4:SetRange(LOCATION_EXTRA)
    e4:SetCondition(c7146.syncon)
    e4:SetOperation(c7146.synop)
    e4:SetValue(SUMMON_TYPE_SYNCHRO)
    c:RegisterEffect(e4)
end

function c7146.indtg(e,c)
    return c==Duel.GetAttacker()
end

function c7146.atkcon(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    return a and a:IsControler(tp) and a:IsType(TYPE_PENDULUM)
end
function c7146.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c7146.atkop(e,tp,eg,ep,ev,re,r,rp)
    local a=Duel.GetAttacker()
    local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
    if not a or g:GetCount()==0 then return end
    local atk=a:GetAttack()
    local gc=g:GetFirst()
    while gc do
       local e1=Effect.CreateEffect(e:GetHandler())
       e1:SetType(EFFECT_TYPE_SINGLE)
       e1:SetCode(EFFECT_UPDATE_ATTACK)
       e1:SetValue(-atk)
       e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
       gc:RegisterEffect(e1)
       gc=g:GetNext()
    end
end

function c7146.synft(c,tp,syn)
    if c:IsFaceup() and c:IsCanBeSynchroMaterial(syn) and (c:IsType(TYPE_TUNER) or (c:IsType(TYPE_PENDULUM) and bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)>0)) then
        local mg=Duel.GetMatchingGroup(c7146.synnt,tp,LOCATION_MZONE,0,c,syn)
        return mg:CheckWithSumEqual(Card.GetOriginalLevel,syn:GetLevel()-c:GetLevel(),1,63,syn)
    else return false end
end
function c7146.synnt(c,syn)
    return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsCanBeSynchroMaterial(syn)
end
function c7146.syncon(e,c)
    if c==nil then return true end
    if c:IsFaceup() then return false end
    local tp=c:GetControler()
    return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2 and Duel.IsExistingMatchingCard(c7146.synft,tp,LOCATION_MZONE,0,1,nil,tp,c)
end
function c7146.spfil1(c,tp,syn)
    if c:IsFaceup() and c:IsCanBeSynchroMaterial(syn) and (c:IsType(TYPE_TUNER) or (c:IsType(TYPE_PENDULUM) and bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)>0)) then
        local mg=Duel.GetMatchingGroup(c7146.synnt,tp,LOCATION_MZONE,0,c,syn)
        return mg:IsExists(c7146.spfil2,1,nil,syn:GetLevel()-c:GetLevel(),mg,syn)
    else return false end
end
function c7146.spfil2(c,limlv,mg,sc)
    local fg=mg:Clone()
    fg:RemoveCard(c)
    local newlim=limlv-c:GetLevel()
    if newlim==0 then return true else return fg:CheckWithSumEqual(Card.GetOriginalLevel,newlim,1,63,sc) end
end
function c7146.synop(e,tp,eg,ep,ev,re,r,rp,c)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
    local g1=Duel.SelectMatchingCard(tp,c7146.spfil1,tp,LOCATION_MZONE,0,1,1,nil,tp,e:GetHandler())
    local tn=g1:GetFirst()
    local cnd=tn:IsType(TYPE_PENDULUM) and bit.band(tn:GetSummonType(),SUMMON_TYPE_PENDULUM)>0
    local tglv=e:GetHandler():GetLevel()
    local lv=tn:GetLevel()
    local g=Group.FromCards(tn)
    local mg=Duel.GetMatchingGroup(c7146.synnt,tp,LOCATION_MZONE,0,tn,e:GetHandler())
    while lv<tglv do
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
        local g2=mg:FilterSelect(tp,c7146.spfil2,1,1,nil,tglv-lv,mg,e:GetHandler())
        local gc=g2:GetFirst()
        lv=lv+gc:GetLevel()
        mg:RemoveCard(gc)
        g:AddCard(gc)
    end
    Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
    Duel.SpecialSummon(e:GetHandler(),SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
    if cnd then e:GetHandler():RegisterFlagEffect(7146,RESET_EVENT+0x1fe0000,0,1)
    e:GetHandler():CompleteProcedure()
end
