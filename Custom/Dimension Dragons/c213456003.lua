--以外目の竜剣士
--Dragon Knight with Different Eyes
--Created and scripted by Eerie Code
function c213456003.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--
	--Pseudo-Pendulum
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,213456003)
	e2:SetCondition(c213456003.spcon)
	e2:SetOperation(c213456003.spop)
	e2:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e2)
	--cannot be material
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e3:SetValue(c213456003.splimit)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e5)
	--synchro level
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_SYNCHRO_LEVEL)
	e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetValue(c213456003.slevel)
	c:RegisterEffect(e6)
end

function c213456003.sppfil(c)
	return c:IsSetCard(0x98) or c:IsSetCard(0x99)
end
function c213456003.spmfil(c)
	return c:IsFaceup() and c:IsSetCard(0x99)
end
function c213456003.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if not tc1 or not tc2 or not c213456003.sppfil(tc1) or not c213456003.sppfil(tc2) then
		--Debug.Message("Wrong cards in Pendulum Zone.")
		return false 
	end
	local scl1=tc1:GetLeftScale()
	local scl2=tc2:GetRightScale()
	if scl1>scl2 then scl1,scl2=scl2,scl1 end
	local lv=c:GetLevel()
	--Debug.Message("Scale from "..scl1.." to "..scl2)
	--Debug.Message("Level: "..lv)
	--return scl1<lv and scl2>lv and Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) and Duel.IsExistingMatchingCard(c213456003.spmfil,tp,LOCATION_MZONE,0,1,nil)
	if scl1>=lv or scl2<=lv then
		--Debug.Message("Wrong Scale.")
		return false
	end
	if not Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,c) then
		--Debug.Message("No card can be discarded.")
		return false
	end
	return Duel.IsExistingMatchingCard(c213456003.spmfil,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c213456003.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,Card.IsDiscardable,tp,LOCATION_HAND,0,1,1,c)
	Duel.SendtoGrave(g,REASON_DISCARD+REASON_COST)
end

function c213456003.splimit(e,c)
	if not c then return false end
	return not c:IsRace(RACE_SPELLCASTER) and not c:IsRace(RACE_DRAGON)
end

function c213456003.slevel(e,c)
	local lv=e:GetHandler():GetLevel()
	--Debug.Message("Normal Level: "..lv)
	--local sylv=(3*65536)+lv
	--Debug.Message("Synchro Level: "..sylv)
	--return sylv
	if c and c:IsRace(RACE_DRAGON) then return 3 else return lv end
end
