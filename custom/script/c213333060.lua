--プレデター・ガーデン
--Predator Garden
--Created and scripted by Eerie Code
function c213333060.initial_effect(c)
	--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c213333060.atktg)
	e1:SetValue(c213333060.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	if EFFECT_UPDATE_DEFENSE then
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
	else
		e2:SetCode(EFFECT_UPDATE_DEFENCE)
	end
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1,213333060)
	e3:SetCost(c213333060.thcost)
	e3:SetTarget(c213333060.thtg)
	e3:SetOperation(c213333060.thop)
	c:RegisterEffect(e3)
end

function c213333060.atktg(e,c)
	return not c:IsAttribute(ATTRIBUTE_DARK) or c:GetCounter(0x3b)>0
end
function c213333060.atkval(e,c)
	return Duel.GetCounter(0,1,1,0x3b)*(-200)
end

function c213333060.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,1,0x3b,2,REASON_COST) end
	Duel.RemoveCounter(tp,1,1,0x3b,2,REASON_COST)
end
function c213333060.thfil(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_PLANT) and c:IsAbleToHand()
end
function c213333060.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c213333060.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c213333060.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c213333060.thfil,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
