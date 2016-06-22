--機殻の凍結
--Qliphort Down
--Scripted by Eerie Code
function c7376.initial_effect(c)
    --
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c7376.cost)
    e1:SetTarget(c7376.tg)
    e1:SetOperation(c7376.op)
    c:RegisterEffect(e1)
    Duel.AddCustomActivityCounter(7376,ACTIVITY_CHAIN,c7376.chainfilter)
end

function c7376.chainfilter(re,tp,cid)
	return not (re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetTriggeringLocation()==LOCATION_ONFIELD and not re:GetHandler():IsSetCard(SET_QLI))
end
function c7376.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(7376,tp,ACTIVITY_CHAIN)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c7376.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c7376.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and re:GetTriggeringLocation()==LOCATION_ONFIELD and not re:GetHandler():IsSetCard(SET_QLI)
end
function c7376.tg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,7376,SET_QLI,0x41,4,1800,1000,RACE_MACHINE,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c7376.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.IsPlayerCanSpecialSummonMonster(tp,7376,SET_QLI,0x21,4,1800,1000,RACE_MACHINE,ATTRIBUTE_EARTH) then
		c:AddMonsterAttribute(0,0,0,0,0)
		Duel.SpecialSummonStep(c,1,tp,tp,true,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_EFFECT+TYPE_MONSTER)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		c:RegisterEffect(e1,true)
		c:RegisterFlagEffect(7376,RESET_EVENT+0x1fe0000,0,1)
		Duel.SpecialSummonComplete()
	end
end
