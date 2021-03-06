--オルターガイスト・マリオネッター
--Altergeist Marionetter
--Scripted by Eerie Code
function c101002012.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101002012,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c101002012.settg)
	e1:SetOperation(c101002012.setop)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101002012,1))
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_SPSUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,101002012)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c101002012.sptg)
	e2:SetOperation(c101002012.spop)
	c:RegisterEffect(e2)
end
function c101002012.setfilter(c)
	return c:IsSetCard(0x205) and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c101002012.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101002012.setfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c101002012.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,c101002012.setfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())		
		Duel.ConfirmCards(1-tp,g)
	end
end
function c101002012.thfilter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x205) and c:IsAbleToGrave()
end
function c101002012.thfilter2(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x205) and c:IsAbleToGrave() and c:GetSequence()<5
end
function c101002012.spfilter(c,e,tp)
	return c:IsSetCard(0x205) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101002012.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then
		local b=false
		if ft>0 then
			b=Duel.IsExistingTarget(c101002012.thfilter1,tp,LOCATION_ONFIELD,0,1,nil)
		else
			b=Duel.IsExistingTarget(c101002012.thfilter2,tp,LOCATION_MZONE,0,1,nil)
		end
		return b and Duel.IsExistingTarget(c101002012.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	end
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	if ft>0 then
		g1=Duel.SelectTarget(tp,c101002012.thfilter1,tp,LOCATION_ONFIELD,0,1,1,nil)
	else
		g1=Duel.SelectTarget(tp,c101002012.thfilter2,tp,LOCATION_ONFIELD,0,1,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c101002012.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g1,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPSUMMON,g2,1,0,0)
end
function c101002012.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=2 then return end
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	if tc1:IsLocation(LOCATION_GRAVE) then tc1,tc2=tc2,tc1 end
	if Duel.SendtoGrave(tc1,REASON_EFFECT)>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.SpecialSummon(tc2,0,tp,tp,false,false,POS_FACEUP)
	end
end
