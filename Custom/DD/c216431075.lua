--戦乙女の禁断契約書
--Forbidden Dark Contract with the Witch
--Created by ＤＤＤ壊死王アビス・アーマゲドン, scripted by Eerie Code
function c216431075.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetHintTiming(0,0x1e0+TIMING_DAMAGE_STEP)
	e1:SetCondition(c216431075.condition)
	e1:SetTarget(c216431075.target)
	e1:SetOperation(c216431075.operation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1021,3))
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCost(c216431075.rmcost)
	e2:SetTarget(c216431075.rmtg)
	e2:SetOperation(c216431075.rmop)
	c:RegisterEffect(e2)
	--leave
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(c216431075.hdcon)
	e5:SetOperation(c216431075.hdop)
	c:RegisterEffect(e5)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10833828,2))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c216431075.damcon)
	e4:SetCost(c216431075.damcost)
	e4:SetTarget(c216431075.damtg)
	e4:SetOperation(c216431075.damop)
	c:RegisterEffect(e4)
end

function c216431075.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c216431075.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(216431075+1)==0 end
	e:GetHandler():RegisterFlagEffect(216431075+1,RESET_PHASE+PHASE_END,0,0)
end
function c216431075.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,2000)
end
function c216431075.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end

function c216431075.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()
end
function c216431075.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then return true end
	local ph=Duel.GetCurrentPhase()
	local b1=c216431075.rmcost(e,tp,eg,ep,ev,re,r,rp,0) and c216431075.rmtg(e,tp,eg,ep,ev,re,r,rp,0) end
	local b2=c216431075.damcon(e,tp,eg,ep,ev,re,r,rp)  and ph==PHASE_STANDBY and c216431075.damcost(e,tp,eg,ep,ev,re,r,rp,0)
	if (b1 or b2) and ph~=PHASE_DAMAGE and Duel.SelectYesNo(tp,94) then
		local op=0
		if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(1021,3),aux.Stringid(10833828,2))
		elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(1021,3))
		else op=Duel.SelectOption(tp,aux.Stringid(10833828,2))+1 end
		e:SetLabel(op)
		if op==0 then
			e:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
			c216431075.rmcost(e,tp,eg,ep,ev,re,r,rp,1)
			c216431075.rmtg(e,tp,eg,ep,ev,re,r,rp,1)
		else
			c216431075.damcost(e,tp,eg,ep,ev,re,r,rp,1)
			c216431075.damtg(e,tp,eg,ep,ev,re,r,rp,1)
		end
	else
		e:SetLabel(2)
		e:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	end
end
function c216431075.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local op=e:GetLabel()
	if op==0 then
		c216431075.rmop(e,tp,eg,ep,ev,re,r,rp)
	elseif op==1 then
		c216431075.damop(e,tp,eg,ep,ev,re,r,rp)
	end
end

function c216431075.rmcfil(c)
	return (c:IsSetCard(0xae) or c:IsSetCard(0xaf)) and c:IsAbleToRemoveAsCost()
end
function c216431075.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c216431075.rmcfil,tp,LOCATION_HAND,0,1,nil) and e:GetHandler():GetFlagEffect(216431075)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c216431075.rmcfil,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetHandler():RegisterFlagEffect(216431075,RESET_PHASE+PHASE_END,0,0)
end
function c216431075.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c216431075.atkfil(c)
	return c:IsFaceup() and c:IsSetCard(0xaf)
end
function c216431075.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c216431075.atkfil,tp,LOCATION_MZONE,0,nil)
	if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 and g:GetCount()>0 then
		local ac=g:GetFirst()
		while ac do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(1000)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			ac:RegisterEffect(e1)
		end
	end
end

function c216431075.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsLocation(LOCATION_DECK)
end
function c216431075.hdop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(c216431075.hdval)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
end
function c216431075.hdval(e,re,dam,r,rp,rc)
	return dam/2
end
