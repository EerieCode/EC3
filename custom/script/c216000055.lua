--スカーレッド・オリジン
--Scarlet Lineage
--Created by ScarletKing, scripted by Eerie Code
function c216000055.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,216000055+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c216000055.cost)
	e1:SetTarget(c216000055.tg)
	e1:SetOperation(c216000055.op)
	c:RegisterEffect(e1)
end
c216000055.red_daemons_list=true

function c216000055.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function c216000055.cfilter(c,e,tp)
	return c:IsSetCard(0x1045) and c:IsType(TYPE_SYNCHRO) and c:IsLevelAbove(1) and Duel.IsExistingMatchingCard(c216000055.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
end
function c216000055.spfil(c,e,tp,lv)
	return c:IsFacedown() and c:IsSetCard(0x1045) and c:IsType(TYPE_SYNCHRO) and math.abs(c:GetLevel()-lv)==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c216000055.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
			and Duel.CheckReleaseGroup(tp,c216000055.cfilter,1,nil,e,tp)
	end
	e:SetLabel(0)
	local g=Duel.SelectReleaseGroup(tp,c216000055.cfilter,1,1,nil,e,tp)
	Duel.Release(g,REASON_COST)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c216000055.op(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c216000055.spfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,tc:GetPreviousLevelOnField())
	local sc=g:GetFirst()
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetOperation(c216000055.desop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		sc:RegisterEffect(e1,true)
	end
end
function c216000055.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
