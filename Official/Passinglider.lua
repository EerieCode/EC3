--ＳＲパッシングライダー
--Speedroid Passing Rider
--Scripted by Eerie Code
function c6145.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6145,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c6145.sccost)
	e1:SetTarget(c6145.sctg)
	e1:SetOperation(c6145.scop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,6145)
	e2:SetCondition(c6145.spccon)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(6145,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c6145.spcon)
	e3:SetTarget(c6145.sptg)
	e3:SetOperation(c6145.spop)
	c:RegisterEffect(e3)
	--at limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetValue(c6145.atlimit)
	c:RegisterEffect(e4)
end

function Card.GetScale(c)
	local seq=c:GetSequence()
	if seq<6 then return 0 end
	if seq==6 then return c:GetLeftScale() else return c:GetRightScale() end
end

function c6145.scfil(c)
	return c:IsSetCard(SET_SR) and c:IsType(TYPE_TUNER) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) 
		and c:IsAbleToGraveAsCost()
end
function c6145.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6145.sccost,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c6145.sccost,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g:GetFirst())
	Duel.SendtoGrave(g,REASON_COST)
end
function c6145.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local op=0
	if c:GetScale()==1 then
		op=Duel.SelectOption(tp,aux.Stringid(6145,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(6145,2),aux.Stringid(6145,3))
	end
	e:SetLabel(op)
end
function c6145.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local lv=e:GetLabelObject():GetOriginalLevel()
	local op=e:GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	if op==0 then
		e1:SetValue(lv)
	else
		if lv>=c:GetScale() then lv=c:GetScale()-1 end
		e1:SetValue(-lv)
	end
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e2)
end

function c6145.spccon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,LOCATION_MZONE)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

function c6145.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function c6145.spfil(c,e,tp)
	return c:IsSetCard(SET_SR) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c6145.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c6145.spfil(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c6145.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c6145.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c6145.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c6145.atlimit(e,c)
	return c:IsFaceup() and c:IsSetCard(SET_SR) and c~=e:GetHandler()
end
