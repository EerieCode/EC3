--Created and scripted by Eerie Code
--The Phantom Knights of Torn Banner
function c216666000.initial_effect(c)
  --Activate effect
  --Phantom Xyz
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_RANGE)
  e2:SetCountLimit(1,216666000+1)
  e2:SetTarget(c216666000.sptg)
  e2:SetOperation(c216666000.spop)
  c:RegisterEffect(e2)
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
