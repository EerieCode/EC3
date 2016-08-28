--Created and scripted by Eerie Code
--Xyz Rider
function c216666059.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,216666059+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c216666059.tg)
	e1:SetOperation(c216666059.op)
	c:RegisterEffect(e1)
end

function c216666059.fil1(c,tp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_WINDBEAST+RACE_DRAGON) and Duel.IsExistingTarget(c216666059.fil2,tp,LOCATION_MZONE,0,1,c)
end
function c216666059.fil2(c)
	return c:IsFaceup() and c:IsAttackAbove(1) and c:IsType(TYPE_XYZ) and c:IsRace(RACE_WARRIOR) and c:GetAttackAnnouncedCount()==0
end
function c216666059.tg(e,tp,ep,eg,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c216666059.fil1,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c216666059.fil1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tc1=g1:GetFirst()
	e:SetLabelObject(tc1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,c216666059.fil2,tp,LOCATION_MZONE,0,1,1,tc1)
end
function c216666059.op(e,tp,ep,eg,ev,re,r,rp)
	local c=e:GetHandler()
	local tc1=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc2=g:GetFirst()
	if tc1==tc2 then tc2=g:GetNext() end
	if tc1:IsRelateToEffect(e) and tc2:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
		e1:SetCode(EFFECT_CANNOT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc2:RegisterEffect(e1)
		local atk=tc2:GetAttack()
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(atk)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc1:RegisterEffect(e2)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e4:SetCode(EVENT_PRE_BATTLE_DAMAGE)
		e4:SetCondition(c216666059.dcon)
		e4:SetOperation(c216666059.dop)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc1:RegisterEffect(e4)
	end
end

function c216666059.dcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c216666059.dop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
