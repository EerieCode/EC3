--捕食植物ナガ・リナンツ
--Predator Plant Naga Rhinanthus
--Created and scripted by Eerie Code
function c213333035.initial_effect(c)
	--
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,69105797,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),1,true,true)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c213333035.atkval)
	c:RegisterEffect(e1)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,213333035)
	e4:SetTarget(c213333035.sptg)
	e4:SetOperation(c213333035.spop)
	c:RegisterEffect(e4)
end

function c213333035.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x1041)*200
end

function c213333035.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bt=e:GetHandler():GetBattleTarget()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerCanSpecialSummonMonster(tp,213333035+1,0,0x4011,-2,-2,4,RACE_PLANT,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
end
function c213333035.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local bt=e:GetHandler():GetBattleTarget()
	local def=0
	if Card.GetBaseDefense then
		def=bt:GetBaseDefense()
	else
		def=bt:GetBaseDefence()
	end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,213333035+1,0,0x4011,-2,-2,4,RACE_PLANT,ATTRIBUTE_DARK) then return end
	local token=Duel.CreateToken(tp,213333035+1)
	Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(bt:GetBaseAttack())
	e1:SetReset(RESET_EVENT+0x1fe0000)
	token:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	e2:SetValue(bt:GetBaseDefense())
	token:RegisterEffect(e2)
	Duel.SpecialSummonComplete()
end
