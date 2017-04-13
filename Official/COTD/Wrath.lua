--覇王の逆鱗
--Supreme King's Wrath
--Scripted by Eerie Code
function c101001070.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101001070.target)
	e1:SetOperation(c101001070.activate)
	c:RegisterEffect(e1)
end
function c101001070.cfilter(c)
	return c:IsFaceup() and c:IsCode(13331639)
end
function c101001070.desfilter(c)
	return not c101001070.cfilter(c)
end
function c101001070.spfilter(c,e,tp)
	return c:IsSetCard(0x20f8) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c101001070.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c101001070.desfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c101001070.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
		and Duel.IsExistingMatchingCard(c101001070.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA)
end
function c101001070.activate(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c101001070.desfilter,tp,LOCATION_MZONE,0,nil)
	if Duel.Destroy(dg,REASON_EFFECT)==0 then return end
	local sg=Duel.GetMatchingGroup(aux.NecrovalleyFilter(c101001070.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,nil,e,tp)
	local lc=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ct=4
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	if sg:GetCount()==0 or lc==0 then return end
	local sel=Group.CreateGroup()
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local s1=sg:Select(tp,1,1,nil)
		sel:Merge(s1)
		sg:Remove(Card.IsCode,nil,s1:GetFirst():GetCode())
		ct=ct-1
		lc=lc-1
	until ct==0 or sg:GetCount()==0 or lc==0 or not Duel.SelectYesNo(tp,aux.Stringid(101001070,0))
	Duel.SpecialSummon(sel,0,tp,tp,true,false,POS_FACEUP)
end
