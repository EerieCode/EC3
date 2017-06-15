--リンク・インフライヤー
--Link In-Flyer
--Scripted by Eerie Code
--incomplete
function c101002003.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(63528891,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,101002003)
	e1:SetCondition(c101002003.spcon)
	c:RegisterEffect(e1)
end
function c101002003.spcon(e,c)
	if c==nil then return true end
  local tp=e:GetHandlerPlayer()
	local zone=Duel.GetLinkedZone(tp)
	return zone~=0 and c:IsCanBeSpecialSummon(e,0,tp,false,false,POS_FACEUP,tp,zone)
end
