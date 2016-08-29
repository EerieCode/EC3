--月光再生融合
--Lunalight Rebirth Fusion
--Created and scripted by Eerie Code
function c213335060.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,213335060+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c213335060.target)
	e1:SetOperation(c213335060.activate)
	c:RegisterEffect(e1)
end

function c213335060.cfilter(c,e,tp)
	return c:IsSetCard(0xdf) and c:IsType(TYPE_FUSION) and not (c:IsLocation(LOCATION_EXTRA) and c:IsFacedown()) and c:IsCanBeEffectTarget(e) and Duel.IsExistingMatchingCard(c213335060.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetOriginalCode())
end
function c213335060.filter(c,e,tp,cd)
	if c:IsSetCard(0xdf) and c:IsType(TYPE_FUSION) and c:IsFacedown() and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c.material then
		for k,v in pairs(c.material) do
			if v==cd then return true end
		end
		return false
	else return false end
end
function c213335060.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c213335060.cfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and eg:IsExists(c213335060.cfilter,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=eg:FilterSelect(tp,c213335060.cfilter,1,1,nil,e,tp)
	Duel.SetTargetCard(g)
end
function c213335060.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c213335060.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetOriginalCode())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
	end
end
