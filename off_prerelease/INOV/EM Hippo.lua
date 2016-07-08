--ＥＭオールカバー・ヒッポ
--Performapal Allcover Hippo
--Scripted by Eerie Code
function c100910003.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100910003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c100910003.sptg)
	e1:SetOperation(c100910003.spop)
	c:RegisterEffect(e1)
	--Change position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100910003,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c100910003.postg)
	e2:SetOperation(c100910003.posop)
	c:RegisterEffect(e2)
end

function c100910003.spfil(c,e,tp)
	return c:IsSetCard(0x9f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c100910003.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c100910003.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c100910003.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c100910003.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c100910003.posfil(c)
	local pos=0
	if POS_DEFENSE then pos=POS_DEFENSE else pos=POS_DEFENCE end
	return not c:IsPosition(pos)
end
function c100910003.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c100910003.posfil,tp,LOCATION_MZONE,0,1,nil) end
end
function c100910003.posop(e,tp,eg,ep,ev,re,r,rp)
	local pos=0
	if POS_FACEUP_DEFENSE then pos=POS_FACEUP_DEFENSE else pos=POS_FACEUP_DEFENCE end
	local g=Duel.GetMatchingGroup(c100910003.posfil,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		Duel.ChangePosition(tc,pos)
		tc=g:GetNext()
	end
end
