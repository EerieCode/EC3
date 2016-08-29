--捕食植物スパイダー・ドロソフィルム
--Predator Plant Spider Drosophyllum
--Created and scripted by Eerie Code
function c213333007.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(-800)
	e1:SetTarget(c213333007.atktg)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	if EFFECT_UPDATE_DEFENSE then
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
	else
		e2:SetCode(EFFECT_UPDATE_DEFENCE)
	end
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c213333007.thtg)
	e4:SetOperation(c213333007.thop)
	c:RegisterEffect(e4)
end

function c213333007.atktg(e,c)
	return c:GetCounter(0x3b)>0
end

function c213333007.thfil(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_PLANT) and c:IsAbleToHand()
end
function c213333007.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c213333007.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c213333007.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c213333007.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
