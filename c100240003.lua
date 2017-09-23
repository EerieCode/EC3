--Odd-Eyes What-the-F Dragon
--Scripted by Eerie Code
function c100240003.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c100240003.cost)
	e1:SetTarget(c100240003.target)
	e1:SetOperation(c100240003.operation)
	c:RegisterEffect(e1)
end
function c100240003.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c100240003.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x98) and c:IsType(TYPE_PENDULUM)
end
function c100240003.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c100240003.filter,tp,LOCATION_EXTRA,0,1,nil) end
end
function c100240003.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=Duel.GetMatchingGroupCount(c100240003.filter,tp,LOCATION_EXTRA,0,nil)
	local ft=math.min(lc,ct)
	if ft<1 or not c:IsRelateToEffect(e) then return end
	local zone=0
	repeat
		local z=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,zone)
		zone=bit.bor(zone,z)
		ft=ft-1
	until ft==0 or not Duel.SelectYesNo(tp,aux.Stringid(100240003,0))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_BECOME_LINKED_ZONE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetValue(zone)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(c100240003.val)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
end
function c100240003.val(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 then
		return dam/2
	else return dam end
end
