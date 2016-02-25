--Scripted by Eerie Code
--Blackwing -  Gofu the Hazy Shadow
function c7112.initial_effect(c)
  c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c7112.spcon)
	c:RegisterEffect(e1)
	--token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7112,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c7112.condition)
	e2:SetTarget(c7112.target)
	e2:SetOperation(c7112.operation)
	c:RegisterEffect(e2)
	--Synchro
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7112,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCost(c7112.spcost)
	e3:SetTarget(c7112.sptg)
	e3:SetOperation(c7112.spop)
	c:RegisterEffect(e3)
end

function c7112.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end

function c7112.condition(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():GetPreviousLocation()==LOCATION_HAND
end
function c7112.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c7112.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,7112+1,0,0x4011,0,0,1,RACE_WINDBEAST,ATTRIBUTE_DARK) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,7112+1)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(1)
		token:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	  token:RegisterEffect(e2,true)
	end
	Duel.SpecialSummonComplete()
end

function c7112.cfilter(c,e,tp,lv)
  return c:IsFaceup() and not c:IsType(TYPE_TUNER) and c:IsLevelAbove(1) and c:IsAbleToRemoveAsCost() and Duel.IsExistingTarget(c7112.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp,lv+c:GetLevel())
end
function c7112.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return c:IsAbleToRemoveAsCost() and Duel.IsExistingMatchingCard(c7112.cfilter,tp,LOCATION_MZONE,0,1,c,e,tp,c:GetLevel()) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
  local g=Duel.SelectMatchingCard(tp,c7112.cfilter,tp,LOCATION_MZONE,0,1,1,c,e,tp,c:GetLevel())
  e:SetLabel(c:GetLevel()+g:GetFirst():GetLevel())
  g:AddCard(c)
  Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c7112.spfil(c,e,tp,lv)
  return c:IsSetCard(0x33) and c:IsType(TYPE_SYNCHRO) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7112.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local lv=e:GetLabel()
  if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c7112.spfil(chkc,e,tp,lv) end
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c7112.spfil,tp,LOCATION_GRAVE,0,1,nil,e,tp,lv) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectTarget(tp,c7112.spfil,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,lv)
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c7112.spop(e,tp,eg,ep,ev,re,r,rp)
  local tc=Duel.GetFirstTarget()
  if tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ADD_TYPE)
		e1:SetValue(TYPE_TUNER)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		Duel.SpecialSummonComplete()
	end
end
