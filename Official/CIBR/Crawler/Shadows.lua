--星遺物に差す影
--Shadows Creeping on the Starrelic
--Scripted by Eerie Code
function c101002057.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--stats up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard(0x204)))
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--special summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(101002057,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c101002057.sptg)
	e4:SetOperation(c101002057.spop)
	c:RegisterEffect(e4)
	--to grave
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(101002057,1))
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_BATTLE_DESTROYED)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCondition(c101002057.tgcon)
	e5:SetTarget(c101002057.tgtg)
	e5:SetOperation(c101002057.tgop)
	c:RegisterEffect(e5)
end
function c101002057.spfilter(c,e,tp)
	return c:IsLevelBelow(2) and c:IsRace(RACE_INSECT) 
		and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN))
end
function c101002057.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101002057.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c101002057.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c101002057.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		local spos=0
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then spos=spos+POS_FACEUP_DEFENSE end
		if tc:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN) then spos=spos+POS_FACEDOWN_DEFENSE end
		Duel.SpecialSummon(tc,0,tp,tp,false,false,spos)
	end
end
function c101002057.cfilter(c,tp)
	local rc=c:GetReasonCard()
	return c:IsReason(REASON_BATTLE) and c:GetPreviousControler()==tp and c:IsType(TYPE_FLIP)
		and rc and rc:IsControler(1-tp) and rc:IsRelateToBattle()
end
function c101002057.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local dc=eg:Filter(c101002057.cfilter,nil,tp):GetFirst()
	if dc then
		e:SetLabelObject(dc:GetReasonCard())
		return true
	else return false end
end
function c101002057.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetLabelObject(),1,0,0)
end
function c101002057.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:IsRelateToBattle() then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
