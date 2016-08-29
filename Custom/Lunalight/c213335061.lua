--月相変化
--Luna Light Phase Change
--Created and scripted by Eerie Code
function c213335061.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,213335061)
	e1:SetCost(c213335061.cost)
	e1:SetTarget(c213335061.tg)
	e1:SetOperation(c213335061.op)
	c:RegisterEffect(e1)
end

function c213335061.cfil(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xdf) and c:IsType(TYPE_FUSION) and c:IsAbleToExtraAsCost() and Duel.IsExistingMatchingCard(c213335061.fil,tp,LOCATION_EXTRA,0,1,nil,e,tp,c:GetAttribute(),c:GetLevel())
end
function c213335061.fil(c,e,tp,attr,lv)
	return c:IsFacedown() and c:IsSetCard(0xdf) and c:IsType(TYPE_FUSION) and c:GetLevel()==lv and not c:IsAttribute(attr) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c213335061.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c213335061.cfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c213335061.cfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	e:SetLabelObject(g:GetFirst())
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c213335061.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c213335061.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local rc=e:GetLabelObject()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c213335061.fil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rc:GetAttribute(),rc:GetLevel())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
