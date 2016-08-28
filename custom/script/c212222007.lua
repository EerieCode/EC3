--Ｎ・ＨＥＲＯ ティーンネクロン
--NEXT HERO - Teen Necron
--Created and scripted by Eerie Code
function c212222007.initial_effect(c)
	--add code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetValue(89252153)
	c:RegisterEffect(e0)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c212222007.sppcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetCondition(c212222007.tgcon)
	e2:SetCost(c212222007.tgcost)
	e2:SetTarget(c212222007.tgtg)
	e2:SetOperation(c212222007.tgop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c212222007.fuscon)
	e3:SetOperation(c212222007.fusop)
	c:RegisterEffect(e3)
end

function c212222007.sppcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetFieldGroupCount(c:GetControler(),0,LOCATION_MZONE)>0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

function c212222007.tgcon(e,tp,eg,ep,ev,re,r,rp)
	if Card.IsSummonType then
		return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL+1)
	else
		return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_SPECIAL+1)==SUMMON_TYPE_SPECIAL+1
	end
end
function c212222007.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,212222007)==0 end
	Duel.RegisterFlagEffect(tp,212222007,RESET_PHASE+PHASE_END,0,1)
end
function c212222007.tgfil(c)
	return c:IsSetCard(0x8) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end
function c212222007.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c212222007.tgfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c212222007.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c212222007.tgfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

function c212222007.fuscfil(c)
	return not c:IsSetCard(0xedf)
end
function c212222007.fuscon(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	return r==REASON_FUSION and rc:IsSetCard(0x8) and not rc:GetMaterial():IsExists(c212222007.fuscfil,1,nil)
end
function c212222007.fusop(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.GetFlagEffect(tp,212222000)~=0 and not Duel.IsPlayerAffectedByEffect(tp,212222000)) or Duel.GetFlagEffect(tp,212222007)~=0 or not Duel.SelectYesNo(tp,aux.Stringid(1016,6)) then return end
	Duel.RegisterFlagEffect(tp,212222000,RESET_CHAIN,0,1)
	Duel.RegisterFlagEffect(tp,212222007,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_CARD,0,212222007)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1015,6))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetTarget(c212222007.sptg)
	e1:SetOperation(c212222007.spop)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e2,true)
	end
end
function c212222007.spfil(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x8) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function c212222007.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c212222007.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c212222007.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c212222007.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	end
end
