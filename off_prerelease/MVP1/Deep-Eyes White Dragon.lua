--ディープアイズ・ホワイト・ドラゴン
--Deep-Eyes White Dragon
--Scripted by Eerie Code
function c7205.initial_effect(c)
  --special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(49460512,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c49460512.spcon)
	e1:SetTarget(c49460512.sptg)
	e1:SetOperation(c49460512.spop)
	c:RegisterEffect(e1)
end

function c49460512.cfilter(c,tp)
	return c:IsSetCard(0xdd) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousPosition(POS_FACEUP) and c:IsReason(REASON_BATTLE) or (rp~=tp and c:IsReason(REASON_EFFECT))
end
function c49460512.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c49460512.cfilter,1,nil,tp)
end
function c49460512.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local mg=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,mg:GetClassCount(Card.GetCode)*600)
end
function c49460512.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsLocation(LOCATION_HAND) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
