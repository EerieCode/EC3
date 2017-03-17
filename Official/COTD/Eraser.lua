--トワイライト・イレイザー
--Twilight Eraser
--Scripted by Eerie Code
function c101001072.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c101001072.condition)
	e1:SetCost(c101001072.cost)
	e1:SetTarget(c101001072.target)
	e1:SetOperation(c101001072.activate)
end
function c101001072.filter1(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x38) 
		and Duel.IsExistingMatchingCard(c101001072.filter2,tp,LOCATION_MZONE,0,1,c,c:GetRace(),c:GetCode())
end
function c101001072.filter2(c,race,code)
	return c:IsFaceup() and c:IsSetCard(0x38) and c:IsRace(race) and not c:IsCode(code)
end
function c101001072.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c101001072.filter1,tp,LOCATION_MZONE,0,1,nil)
end
function c101001072.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x38) and c:IsAbleToRemoveAsCost()
end
function c101001072.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101001072.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c101001072.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c101001072.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c101001072.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	end
end
