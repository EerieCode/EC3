--Created and scripted by Eerie Code
--The Phantom Knights of Ruptured Pouch
function c216666005.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,216666005)
	e1:SetTarget(c216666005.sptg)
	e1:SetOperation(c216666005.spop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c216666005.spcon)
	c:RegisterEffect(e2)
	--Material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,216666005+1)
	e3:SetTarget(c216666005.target)
	e3:SetOperation(c216666005.operation)
	c:RegisterEffect(e3)
end

function c216666005.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE)
end
function c216666005.spfil(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x10db) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and not c:IsCode(216666005)
end
function c216666005.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c216666005.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c216666005.spop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c216666005.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end

function c216666005.filter1(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_DARK) and c:GetOverlayCount()==0
end
function c216666005.filter2(c)
	return c:IsSetCard(0x10db) and not c:IsCode(216666005)
end
function c216666005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c216666005.filter1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(c216666005.filter2,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(19310321,1))
	local g1=Duel.SelectTarget(tp,c216666005.filter1,tp,LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(19310321,2))
	local g2=Duel.SelectTarget(tp,c216666005.filter2,tp,LOCATION_REMOVED,0,1,1,nil)
end
function c216666005.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local c=e:GetHandler()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or not c:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,tc,e)
	if g:GetCount()>0 then
		g:AddCard(c)
		Duel.Overlay(tc,g)
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		e1:SetTarget(c216666005.rmtg)
		e1:SetTargetRange(LOCATION_OVERLAY,LOCATION_OVERLAY)
		e1:SetLabelObject(c)
		e1:SetReset(RESET_PHASE+PHASE_END,3)
		--c:RegisterEffect(e1,true)
		Duel.RegisterEffect(e1,0)
	end
end
function c216666005.rmcon(e)
	local c=e:GetHandler()
	--Debug.Message("Previous location: "..c:GetPreviousLocation())
	return c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c216666005.rmtg(e,c)
	local lc=e:GetLabelObject()
	if lc then
		--Debug.Message("Label code: "..lc:GetCode())
		--Debug.Message("Target code: "..c:GetCode())
		return c==lc
	else
		--Debug.Message("Error with label object")
		return false
	end
end
