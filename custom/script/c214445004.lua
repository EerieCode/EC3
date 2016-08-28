--地縛囚人グランド・キーパー
--Earthbound Prisoner Ground Keeper
--Altered by ScarletKing, scripted by Eerie Code
function c214445004.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,214445004)
	e1:SetTarget(c214445004.thtg)
	e1:SetOperation(c214445004.thop)
	c:RegisterEffect(e1)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetCondition(c214445004.tgcon)
	e5:SetTarget(c214445004.tgtg)
	e5:SetOperation(c214445004.tgop)
	c:RegisterEffect(e5)
end

function c214445004.thfil(c)
	return c:IsType(TYPE_FIELD) and c:IsAbleToHand()
end
function c214445004.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c214445004.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c214445004.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c214445004.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c214445004.tgcfil(c)
	return c:IsFaceup() and c:IsType(TYPE_FIELD)
end
function c214445004.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c214445004.tgcfil,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
end
function c214445004.tgfil(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1e21) and not c:IsCode(214445004) and c:IsAbleToGrave()
end
function c214445004.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c214445004.tgfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c214445004.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c214445004.tgfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
