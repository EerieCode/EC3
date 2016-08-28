--光波求道者
--Cipher Scanner
--Created by PK2, scripted by Eerie Code
function c212000002.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,212000002)
	e1:SetTarget(c212000002.tg)
	e1:SetOperation(c212000002.op)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,212000002+1)
	e2:SetCost(c212000002.thcost)
	e2:SetTarget(c212000002.thtg)
	e2:SetOperation(c212000002.thop)
	c:RegisterEffect(e2)
end

function c212000002.cfil(c,e,tp,eg,ep,ev,re,r,rp,xc)
	if c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and c:IsAbleToGraveAsCost() then
		local te=c:CheckActivateEffect(true,true,false)
		if te==nil then return false end
		return te:GetTarget()(e,tp,eg,ep,ev,re,r,rp,0,xc)
	else return false end
end
function c212000002.fil(c,e,tp,eg,ep,ev,re,r,rp)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x107b) and Duel.IsExistingMatchingCard(c212000002.cfil,tp,LOCATION_DECK,0,1,nil,e,tp,eg,ep,ev,re,r,rp,c)
end
function c212000002.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then return c:IsDiscardable() and Duel.IsExistingTarget(c212000002.fil,tp,LOCATION_MZONE,0,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local xg=Duel.SelectTarget(tp,c212000002.fil,tp,LOCATION_MZONE,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp)
	local xc=xg:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c212000002.cfil,tp,LOCATION_DECK,0,1,1,nil,e,tp,eg,ep,ev,re,r,rp,xc)
	local te=g:GetFirst():CheckActivateEffect(true,true,false)
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(te)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	Duel.SetTargetCard(xc)
end
function c212000002.op(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end

function c212000002.thcfil(c)
	return c:IsSetCard(0x7b) and c:IsType(TYPE_XYZ) and c:IsAbleToRemoveAsCost()
end
function c212000002.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c212000002.thcfil,tp,LOCATION_GRAVE,0,nil)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() and g:GetClassCount(Card.GetCode)>=3 end
	local rg=Group.FromCards(e:GetHandler())
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,1,1,nil)
		local rc=sg:GetFirst()
		rg:AddCard(rc)
		g:Remove(Card.IsCode,nil,rc:GetCode())
	end
	Duel.Remove(rg,POS_FACEUP,REASON_COST)
end
function c212000002.thfil(c)
	return c:IsSetCard(0x95) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c212000002.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c212000002.thfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c212000002.thfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c212000002.thfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c212000002.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
