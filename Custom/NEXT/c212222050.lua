--摩天楼ネオ－ヒーローアカデミア
--Skyscraper Neo - Hero Academy
--Created and scripted by Eerie Code
function c212222050.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,212222050)
	e2:SetCost(c212222050.spcost)
	e2:SetTarget(c212222050.sptg)
	e2:SetOperation(c212222050.spop)
	c:RegisterEffect(e2)
end

function c212222050.spfilter(c)
	return c:IsSetCard(0x46) and c:IsType(TYPE_SPELL) and c:IsAbleToRemoveAsCost()
end
function c212222050.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c212222050.spfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c212222050.spfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c212222050.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c212222050.filter2(c,e,tp,m,f,chkf,ex)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x3008) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,ex,chkf)
end
function c212222050.exfilter0(c,e,tp,m,f,chkf)
	return c:IsSetCard(0x8) and c:IsSetCard(0xedf) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c212222050.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,m,f,chkf,c)
end
function c212222050.exfilter1(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x3008) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and Duel.IsExistingMatchingCard(c212222050.exfilter2,tp,LOCATION_DECK,0,1,nil,e,tp,m,f,chkf,c)
end
function c212222050.exfilter2(c,e,tp,m,f,chkf,fc)
	return c:IsSetCard(0x8) and c:IsSetCard(0xedf) and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and not c:IsImmuneToEffect(e) and fc:CheckFusionMaterial(m,c,chkf)
end
function c212222050.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
		local res=Duel.IsExistingMatchingCard(c212222050.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf,nil)
		if not res then
			res=Duel.IsExistingMatchingCard(c212222050.exfilter0,tp,LOCATION_DECK,0,1,nil,e,tp,mg1,nil,chkf)
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c212222050.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c212222050.filter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c212222050.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf,nil)
	local sg2=Duel.GetMatchingGroup(c212222050.exfilter1,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	if sg2:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(1016,8)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg2:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local dmg=Duel.SelectMatchingCard(tp,c212222050.exfilter2,tp,LOCATION_DECK,0,1,1,nil,e,tp,mg1,nil,chkf,tc)
		local dm=dmg:GetFirst()
		local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,dm,chkf)
		mat1:AddCard(dm)
		tc:SetMaterial(mat1)
		Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg1:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
		tc:SetMaterial(mat1)
		Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	end
end
