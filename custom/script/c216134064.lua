--パスト・オーバーレイ
--Critical Overlay
--Altered by F0futurehope, scripted by Eerie Code
function c216134064.initial_effect(c)
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
	e2:SetCountLimit(1,216134064)
	e2:SetCondition(c216134064.con)
	e2:SetTarget(c216134064.tg)
	e2:SetOperation(c216134064.op)
	c:RegisterEffect(e2)
end

function c216134064.con(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return (ph==PHASE_MAIN1 or ph==PHASE_MAIN2 or (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE))
end
function c216134064.spfil1(c,e,tp)
	return c:IsFaceup() and c:IsCode(216134000) and Duel.IsExistingTarget(c216134064.spfil2,tp,0,LOCATION_MZONE,1,nil,e,tp,c)
end
function c216134064.spfil2(c,e,tp,eye)
	if c:IsFaceup() and c:IsLevelAbove(1) then
		local lv=0
		if c:IsLevelBelow(4) then lv=4
		elseif c:IsLevelAbove(7) then lv=8
		else lv=6 end
		return Duel.IsExistingMatchingCard(c216134064.xyzfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,eye,lv)
	else return false end
end
function c216134064.xyzfil(c,e,tp,eye,rk)
	return c:IsFacedown() and c:IsType(TYPE_XYZ) and c:GetRank()==rk and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ+0x20,tp,false,false) and eye:IsCanBeXyzMaterial(c)
end
function c216134064.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c216134064.spfil1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g1=Duel.SelectTarget(tp,c216134064.spfil1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local eye=g1:GetFirst()
	e:SetLabelObject(eye)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c216134064.spfil2,tp,0,LOCATION_MZONE,1,1,nil,e,tp,eye)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c216134064.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if tg:GetCount()~=2 then return end
	local eye=tg:GetFirst()
	local oc=tg:GetNext()
	if eye~=e:GetLabelObject() then eye,oc=oc,eye end
	local rk=0
	if oc:IsLevelBelow(4) then rk=4 elseif oc:IsLevelAbove(7) then rk=8 else rk=6 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c216134064.xyzfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,eye,rk)
	if g:GetCount()==0 then return end
	local sc=g:GetFirst()
	sc:SetMaterial(Group.FromCards(eye))
	Duel.Overlay(sc,Group.FromCards(eye))
	if Duel.SpecialSummonStep(sc,SUMMON_TYPE_XYZ+0x20,tp,tp,false,false,POS_FACEUP) then
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
		e2:SetTarget(c216134064.destg)
		e2:SetOperation(c216134064.desop)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		sc:RegisterEffect(e2)
		sc:CompleteProcedure()
		Duel.SpecialSummonComplete()
	end
end
function c216134064.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c216134064.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
