--Created and scripted by Eerie Code
--The Phantom Knights of Torn Banner
function c216666000.initial_effect(c)
  --Activate effect
  local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_TODECK)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,216666000)
  e1:SetTarget(c216666000.tdtg)
  e1:SetOperation(c216666000.tdop)
  c:RegisterEffect(e1)
  --Phantom Xyz
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_RANGE)
  e2:SetCountLimit(1,216666000+1)
  e2:SetCost(c216666000.spcost)
  e2:SetTarget(c216666000.sptg)
  e2:SetOperation(c216666000.spop)
  c:RegisterEffect(e2)
end

function c216666000.tdfil(c)
	return c:IsSetCard(0xdb) and not c:IsCode(216666000) and c:IsAbleToDeck()
end
function c216666000.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and chkc:IsControler(tp) and c216666000.tdfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c216666000.tdfil,tp,LOCATION_REMOVED,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c216666000.tdfil,tp,LOCATION_REMOVED,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c216666000.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
	end
end

function c216666000.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c216666000.mfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xdb) and not c:IsType(TYPE_TOKEN+TYPE_XYZ)
end
function c216666000.xyzfilter(c,mg)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsXyzSummonable(mg)
end
function c216666000.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(c216666000.mfilter,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(c216666000.xyzfilter,tp,LOCATION_DECK,0,1,nil,g)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c216666000.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c216666000.mfilter,tp,LOCATION_MZONE,0,nil)
	local xyzg=Duel.GetMatchingGroup(c216666000.xyzfilter,tp,LOCATION_DECK,0,nil,g)
	if xyzg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local sg=g:FilterSelect(tp,xyz.xyz_filter,xyz.xyz_count,xyz.xyz_count,nil)
		Duel.XyzSummon(tp,xyz,sg)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x47e0000)
		e1:SetValue(LOCATION_EXTRA)
		xyz:RegisterEffect(e1,true)
	end
end
