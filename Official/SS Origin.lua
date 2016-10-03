--超戦士の萌芽
--Super Soldier Origin
--Scripted by Eerie Code
function c7562.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,7562+EFFECT_FLAG_COUNT_OATH)
	e1:SetTarget(c7562.tg)
	e1:SetOperation(c7562.op)
	c:RegisterEffect(e1)
end

function c7562.spfil(c,e,tp)
	return c:IsSetCard(SET_CS) and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,false) and Duel.IsExistingMatchingCard(c7562.cfil1,tp,LOCATION_HAND,0,1,c,tp)
end
function c7562.cfil1(c,tp)
	return c:IsLevelBelow(7) and c:IsAttribute(ATTRIBUTE_LIGHT+ATTRIBUTE_DARK) and c:IsAbleToGraveAsCost() and Duel.IsExistingMatchingCard(c7562.cfil2,tp,LOCATION_DECK,0,1,nil,c:GetAttribute(),c:GetLevel())
end
function c7562.cfil2(c,att1,lv1)
	local att2=ATTRIBUTE_DARK
	if att1==att2 then att2=ATTRIBUTE_LIGHT end
	return c:IsAttribute(att2) and c:GetLevel()+lv1==8 and c:IsAbleToGraveAsCost()
end
function c7562.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c7562.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c7562.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c7562.spfil,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local sc=sg:GetFirst()
	if not sc then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c7562.cfil1,tp,LOCATION_HAND,0,1,1,sc,tp)
	if g1:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c7562.cfil2,tp,LOCATION_DECK,0,1,1,nil,g1:GetFirst():GetAttribute(),g1:GetFirst():GetLevel())
	if g2:GetCount()==0 then return end
	g1:Merge(g2)
	sc:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_COST+REASON_RITUAL+REASON_MATERIAL)
	Duel.BreakEffect()
	Duel.SpecialSummon(sc,SUMMON_TYPE_RITUAL,tp,tp,false,false,POS_FACEUP)
	sc:CompleteProcedure()
end
