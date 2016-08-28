--写真融合
--Montage Fusion
--Altered by F0futurehope, scripted by Eerie Code
function c216134062.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1,216134062)
	e2:SetCondition(c216134062.con)
	e2:SetTarget(c216134062.tg)
	e2:SetOperation(c216134062.op)
	c:RegisterEffect(e2)
end

function c216134062.con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
end
function c216134062.spfil1(c,e,tp)
	return c:IsFaceup() and c:IsCode(216134000) and c:IsCanBeFusionMaterial() and c:IsAbleToGrave() and Duel.IsExistingMatchingCard(c216134062.spfil2,tp,0,LOCATION_MZONE,1,nil,e,tp,c)
end
function c216134062.spfil2(c,e,tp,eye)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and Duel.IsExistingMatchingCard(c216134062.fusfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,eye,c)
end
function c216134062.fusfil(c,e,tp,eye,oc)
	local g=Group.FromCards(eye,oc)
	return c:IsFacedown() and c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION+0x20,tp,false,false) and c:CheckFusionMaterial(g)
end
function c216134062.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c216134062.spfil1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c216134062.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c216134062.spfil1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local eye=g1:GetFirst()
	if not eye then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectMatchingCard(tp,c216134062.spfil2,tp,0,LOCATION_MZONE,1,1,nil,e,tp,eye)
	local oc=g2:GetFirst()
	if not oc then return end
	Duel.HintSelection(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c216134062.fusfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,eye,oc)
	local sc=sg:GetFirst()
	if not sc then return end
	if Duel.SendtoGrave(eye,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)>0 and Duel.SpecialSummonStep(sc,SUMMON_TYPE_FUSION+0x20,tp,tp,false,false,POS_FACEUP) then
		Duel.BreakEffect()
		local attr=oc:GetAttribute()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e1:SetValue(attr)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c) 
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCountLimit(1)
		e2:SetTarget(c216134062.destg)
		e2:SetOperation(c216134062.desop)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		sc:RegisterEffect(e2)
		sc:CompleteProcedure()
		Duel.SpecialSummonComplete()
	end
end
function c216134062.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c216134062.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
