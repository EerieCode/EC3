--光波反射
--Cipher Reflection
--Created by Wave., scripted by Eerie Code
function c212000053.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,212000053+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c212000053.cost)
	e1:SetTarget(c212000053.tg)
	e1:SetOperation(c212000053.op)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(212000053,ACTIVITY_SPSUMMON,c212000053.counterfilter)
end
function c212000053.counterfilter(c)
	return c:IsSetCard(0xe5)
end

function c212000053.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(212000053,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c212000053.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c212000053.splimit(e,c)
	return not c:IsSetCard(0xe5)
end

function c212000053.fil(c,tp)
	return c:IsFaceup() and c:IsSetCard(0xe5) and c:IsLevelAbove(1) and Duel.IsPlayerCanSpecialSummonMonster(tp,212000053,0xe5,0x11,c:GetAttack(),c:GetDefense(),c:GetLevel(),c:GetRace(),c:GetAttribute())
end
function c212000053.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c212000053.fil(chkc,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c212000053.fil,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c212000053.fil,tp,LOCATION_MZONE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c212000053.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local attr=tc:GetAttribute()
	local race=tc:GetRace()
	local lv=tc:GetLevel()
	local atk=tc:GetAttack()
	local def=tc:GetDefense()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not c:IsFacedown() and Duel.IsPlayerCanSpecialSummonMonster(tp,212000053,0xe5,0x11,atk,def,lv,race,attr) then
		c:AddMonsterAttribute(TYPE_NORMAL,attr,race,lv,atk,def)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
		local code=tc:GetOriginalCodeRule()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
		Duel.SpecialSummonComplete()
	end
end
