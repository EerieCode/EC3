--World’s End Circus - Demon Tamer
--Created by Drakylon
--Scripted by Eerie Code
function c213334002.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetTarget(c213334002.sptg)
	e1:SetOperation(c213334002.spop)
	c:RegisterEffect(e1)
	--extra summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c213334002.regcon)
	e2:SetOperation(c213334002.regop)
	c:RegisterEffect(e2)
end

function c213334002.spfil(c,e,tp)
	return c:IsSetCard(0x1edc) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c213334002.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local loc=LOCATION_HAND
		local dg=Duel.GetDecktopGroup(tp,1)
		if dg:GetCount()>0 and dg:FilterCount(Card.IsAbleToRemove,nil)==1 then loc=LOCATION_HAND+LOCATION_DECK end
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c213334002.spfil,tp,loc,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c213334002.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local loc=LOCATION_HAND
	local dg=Duel.GetDecktopGroup(tp,1)
	if dg:GetCount()>0 and dg:FilterCount(Card.IsAbleToRemove,nil)==1 then loc=LOCATION_HAND+LOCATION_DECK end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c213334002.spfil,tp,loc,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) and tc:GetPreviousLocation()==LOCATION_DECK then
		Duel.Remove(dg,POS_FACEDOWN,REASON_EFFECT)
	end
end

function c213334002.regcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return rc:IsSetCard(0xedc)
end
function c213334002.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x1edc))
	e1:SetOperation(c213334002.rmop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
end
function c213334002.rmop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetDecktopGroup(tp,1)
	Duel.Remove(dg,POS_FACEDOWN,REASON_COST)
end
