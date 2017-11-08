--おジャマパーティ
--Ojamaparty
--Scripted by Eerie Code
function c100407024.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100407024.target)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100407024,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,100407024)
	e2:SetCondition(c100407024.thcon)
	e2:SetTarget(c100407024.thtg)
	e2:SetOperation(c100407024.thop)
	c:RegisterEffect(e2)
end
function c100407024.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if c100407024.thcon(e,tp,eg,ep,ev,re,r,rp)
		and c100407024.thtg(e,tp,eg,ep,ev,re,r,rp,0)
		and Duel.SelectYesNo(tp,94) then
		Duel.RegisterFlagEffect(tp,100407024,RESET_PHASE+PHASE_END,0,0)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_HANDES)
		e:SetOperation(c100407024.thop)
		c100407024.thtg(e,tp,eg,ep,ev,re,r,rp,1)
	else
		e:SetCategory(0)
		e:SetOperation(nil)
	end
end
function c100407024.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN
end
function c100407024.thfilter(c)
	return c:IsSetCard(0xf) and c:IsAbleToHand()
end
function c100407024.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100407024)==0
		and Duel.IsExistingMatchingCard(tp,c100407024.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c100407024.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c100407024.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 and Duel.SendtoHand(g,nil,REASON_EFFECT)>0 then
		Duel.BreakEffect()
		Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT,nil)
	end
end
