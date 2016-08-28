--地縛囚人ストーン・スィーパー
--Earthbound Prisoner Stone Sweeper
--Altered by ScarletKing, scripted by Eerie Code
function c214445001.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,214445001)
	e1:SetCondition(c214445001.spcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--to hand
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,214445001+1)
	e5:SetCondition(c214445001.thcon)
	e5:SetTarget(c214445001.thtg)
	e5:SetOperation(c214445001.thop)
	c:RegisterEffect(e5)
end

function c214445001.spfil(c)
	return c:IsFaceup() and c:IsType(TYPE_FIELD)
end
function c214445001.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c214445001.spfil,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
end

function c214445001.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c214445001.thfilter(c)
	return (c:IsSetCard(0x21) or c:IsSetCard(0x1e21)) and c:IsType(TYPE_MONSTER) and not c:IsCode(214445001) and c:IsAbleToHand()
end
function c214445001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c214445001.thfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c214445001.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c214445001.thfilter,tp,LOCATION_GRAVE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
