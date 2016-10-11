--幻影騎士団グリザイユマージ
--Created and scripted by Eerie Code
function c1.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c1.tg)
	e1:SetOperation(c1.op)
	c:RegisterEffect(e1)
end

function c1.fil(c)
	return c:IsFaceup() and c:GetLevel()==0
end
function c1.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c1.fil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c1.fil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c1.fil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c1.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SYNCHRO_LEVEL)
		e2:SetValue(c1.synval)
		tc:RegisterEffect(e2)
	end
end
function c1.synval(e,c)
	return c:GetRank()
end
