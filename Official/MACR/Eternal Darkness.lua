--常闇の契約書
--Dark Contract with the Eternal Darkness
--Scripted by Eerie Code
function c100912068.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--cannot activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetPlayer(0,1)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c100912068.condition)
	c:RegisterEffect(e2)
end
function c100912068.condition(e,tp,eg,ep,ev,re,r,rp)
	local pc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local pc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	return pc1 and pc2 and pc1:IsSetCard(0xaf) and pc2:IsSetCard(0xaf)
end
