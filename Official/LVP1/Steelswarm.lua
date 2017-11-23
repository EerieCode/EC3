--インヴェルズ・オリジン
--Steelswarm Origin
--Scripted by Eerie Code
--Requires a core update in order to work
function c61888819.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xa),2,2)
	--extra restriction
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_FORCE_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,1)
	e1:SetCondition(c61888819.excon)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_EXTRA))
	e1:SetValue(c61888819.exval)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c61888819.indcon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c61888819.spcon)
	e5:SetTarget(c61888819.sptg)
	e5:SetOperation(c61888819.spop)
	c:RegisterEffect(e5)
end
function c61888819.excon(e)
	return e:GetHandler():GetSequence()>=5
end
function c61888819.exval(e)
	local c=e:GetHandler()
	local zone=c:GetLinkedZone()
	return zone & (2^5 & 2^6)
end
function c61888819.indcon(e)
	return e:GetHandler():GetLinkedGroupCount()>0
end
function c61888819.spcfilter(c)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:IsReason(REASON_BATTLE+REASON_EFFECT)
end
function c61888819.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c61888819.spcfilter,1,nil)
end
function c61888819.spfilter(c,e,tp)
	return c:IsSetCard(0xa) and c:IsLevel(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c61888819.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c61888819.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c61888819.spop(e,tp,eg,ep,ev,re,r,rp)
	local ct=math.min(Duel.GetLocationCount(tp,LOCATION_MZONE),eg:GetCount())
	if ct<1 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c61888819.spfilter,tp,LOCATION_DECK,0,1,ct,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
