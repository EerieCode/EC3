--パスト・チューニング
--Critical Tuning
--Altered by F0futurehope, scripted by Eerie Code
function c216134063.initial_effect(c)
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
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,216134063)
	e2:SetCondition(c216134063.con)
	e2:SetTarget(c216134063.tg)
	e2:SetOperation(c216134063.op)
	c:RegisterEffect(e2)
end

function c216134063.con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
end
function c216134063.tgfil(c)
	return c:IsFaceup() and c:IsCode(216134000) and c:IsAbleToGrave()
end
function c216134063.spfil(c,e,tp)
	if c:IsFaceup() and c:IsLevelAbove(1) then
		local lv=0
		if c:IsLevelBelow(4) then lv=4
		elseif c:IsLevelAbove(7) then lv=8
		else lv=6 end
		return Duel.IsExistingMatchingCard(c216134063.synfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv)
	else return false end
end
function c216134063.synfil(c,e,tp,lv)
	return c:IsFacedown() and c:IsType(TYPE_SYNCHRO) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SYNCHRO+0x20,tp,false,false)
end
function c216134063.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c216134063.spfil(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c216134063.tgfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(c216134063.spfil,tp,0,LOCATION_MZONE,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c216134063.spfil,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c216134063.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c216134063.tgfil,tp,LOCATION_MZONE,0,1,1,nil)
	if g1:GetCount()==0 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local lv=0
	if tc:IsLevelBelow(4) then lv=4 elseif tc:IsLevelAbove(7) then lv=8 else lv=6 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c216134063.synfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	if g:GetCount()==0 then return end
	local sc=g:GetFirst()
	if Duel.SendtoGrave(g1,REASON_EFFECT+REASON_MATERIAL+REASON_SYNCHRO)>0 and Duel.SpecialSummonStep(sc,SUMMON_TYPE_SYNCHRO+0x20,tp,tp,false,false,POS_FACEUP) then
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
		e2:SetTarget(c216134063.destg)
		e2:SetOperation(c216134063.desop)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		sc:RegisterEffect(e2)
		sc:CompleteProcedure()
		Duel.SpecialSummonComplete()
	end
end
function c216134063.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c216134063.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
