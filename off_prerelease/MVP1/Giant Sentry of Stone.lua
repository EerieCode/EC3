--Scripted by Eerie Code
--Giant Sentry of Stone
function c7212.initial_effect(c)
  --Special Summon
  local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7212,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,7212)
	e2:SetCondition(c7212.spcon)
	e2:SetTarget(c7212.sptg)
	e2:SetOperation(c7212.spop)
	c:RegisterEffect(e2)
end

function c7212.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x70)
end
function c7212.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
		and not Duel.IsExistingMatchingCard(c7212.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c7212.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c7212.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
