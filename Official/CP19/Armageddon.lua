--DDD超死偉王ダークネス・ヘル・アーマゲドン
--D/D/D Superdoom King Darkness Armageddon
--Scripted by Eerie Code
function c100217008.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x10af),8,2)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100217008,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c100217008.spcon)
	e1:SetTarget(c100217008.sptg)
	e1:SetOperation(c100217008.spop)
	c:RegisterEffect(e1)
end
function c100217008.spcon(e,tp,eg,ep,ev,re,r,rp)
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-e:GetHandler():GetSequence())
	return pc and pc:IsSetCard(0xaf)
end
function c100217008.spfilter(c,e,tp)
	return c:IsSetCard(0x10af) and c:IsType(TYPE_XYZ) and not c:IsCode(100217008)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100217008.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c100217008.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c100217008.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100217008.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
