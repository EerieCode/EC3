--デコード・トーカー
--Decode Talker
--Scripted by Eerie Code
function c100317041.initial_effect(c)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsType,TYPE_EFFECT),2)
	--Update attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c100317041.atkval)
	c:RegisterEffect(e1)
	--negate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100317041,0))
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c100317041.discon)
	e2:SetCost(c100317041.discost)
	e2:SetTarget(c100317041.distg)
	e2:SetOperation(c100317041.disop)
	c:RegisterEffect(e2)
end
function c100317041.atkfilter(c,lc)
	return c:IsLinkedTo(lc)
end
function c100317041.atkval(e,c)
	return Duel.GetMatchingGroupCount(c100317041.atkfilter,e:GetHandlerPlayer(),LOCATION_MZONE,LOCATION_MZONE,nil,e:GetHandler())*500
end
function c100317041.discon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return tg and tg:IsExists(Card.IsOnField,1,nil) and rp~=tp and Duel.IsChainNegatable(ev)
end
function c100317041.costfilter(c,lc)
	return c100317041.atkfilter(c,lc) and not c:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c100317041.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c100317041.costfilter,1,nil,e:GetHandler()) end
	local sg=Duel.SelectReleaseGroup(tp,c100317041.costfilter,1,1,nil,e:GetHandler())
	Duel.Release(sg,REASON_COST)
end
function c100317041.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c100317041.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
