--捕食植物キメラフレシア
--Predator Plant Chimera Rafflesia
--Scripted by Eerie Code
function c7609.initial_effect(c)
	--Fusion Materials
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0xf3),aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_DARK),true)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7609,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c7609.rmtg)
	e1:SetOperation(c7609.rmop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetDescription(aux.Stringid(7609,1))
	e2:SetCondition(c7609.atkcon)
	e2:SetOperation(c7609.atkop)
	c:RegisterEffect(e2)
	--to grave
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetOperation(c7609.regop)
	c:RegisterEffect(e3)
end

function c7609.rmfil(c,lv)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsLevelBelow(lv) and c:IsAbleToRemove()
end
function c7609.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c7609.rmfil(chkc,lv) end
	if chk==0 then return Duel.IsExistingTarget(c7609.rmfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,lv) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c7609.rmfil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,lv)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c7609.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end

function c7609.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	return bc and bc:IsFaceup() and bc:IsControler(1-tp)
end
function c7609.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc:IsRelateToBattle() and bc:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		bc:RegisterEffect(e1)
		if c:IsFaceup() and c:IsRelateToBattle() then
			local e2=e1:Clone()
			e2:SetValue(1000)
			c:RegisterEffect(e2)
		end
	end
end

function c7609.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsPreviousLocation(LOCATION_ONFIELD) then
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetRange(LOCATION_GRAVE)
		e1:SetCountLimit(1)
		e1:SetTarget(c7609.thtg)
		e1:SetOperation(c7609.thop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c7609.thfilter(c)
	return c:IsSetCard(0x46) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c7609.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7609.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c7609.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c7609.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
