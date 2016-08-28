--捕食植物キメラフレシア
--Predator Plant Chimera Rafflesia
--Updated and scripted by Eerie Code
function c213333000.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsRace,RACE_PLANT),2,true)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c213333000.cttg)
	e1:SetOperation(c213333000.ctop)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_F)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c213333000.condition)
	e2:SetCost(c213333000.cost)
	e2:SetOperation(c213333000.operation)
	c:RegisterEffect(e2)
end

function c213333000.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,g,g:GetCount(),0x3b,1)
end
function c213333000.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x3b,1)
		tc=g:GetNext()
	end
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetTarget(c213333000.lvtg)
	e3:SetValue(1)
	Duel.RegisterEffect(e3,0)
end
function c213333000.lvtg(e,c)
	return c:GetCounter(0x3b)>0 and c:IsLevelAbove(1)
end

function c213333000.condition(e,tp,eg,ep,ev,re,r,rp)
	local bt=e:GetHandler():GetBattleTarget()
	return bt --and bt:GetCounter(0x3b)>0
end
function c213333000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(213333000)==0 end
	c:RegisterFlagEffect(213333000,RESET_CHAIN,0,1)
end
function c213333000.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bt=c:GetBattleTarget()
	if not bt or not bt:IsRelateToBattle() then return end
	local ocatk=bt:GetAttack()
	local obatk=bt:GetBaseAttack()
	local dif=math.abs(ocatk-obatk)
	if dif~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(obatk)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		bt:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(dif)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e2)
	end
end
