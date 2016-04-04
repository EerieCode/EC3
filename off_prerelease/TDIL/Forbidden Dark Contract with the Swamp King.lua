--Scripted by Eerie Code
--Forbidden Dark Contract with the Swamp King
function c7156.initial_effect(c)
  --Activate
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_ACTIVATE)
  e0:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e0)
  --Special Summon
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(7156,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_IGNITION)
  e1:SetRange(LOCATION_SZONE)
  e1:SetCountLimit(1)
  e1:SetTarget(c7156.sptg)
  e1:SetOperation(c7156.spop)
  c:RegisterEffect(e1)
  --Fusion Summon
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(7156,1))
  e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_SZONE)
  e2:SetCountLimit(1)
  e2:SetTarget(c7156.fstg)
  e2:SetOperation(c7156.fsop)
  c:RegisterEffect(e2)
  --damage
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c7156.damcon)
	e3:SetTarget(c7156.damtg)
	e3:SetOperation(c7156.damop)
	c:RegisterEffect(e3)
end

function c7156.spfil(c,e,tp)
  return c:IsSetCard(0x10af) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7156.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c7156.spfil,tp,LOCATION_HAND,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c7156.spop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) or Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
  local g=Duel.SelectMatchingCard(tp,c7156.spfil,tp,LOCATION_HAND,0,1,1,nil,e,tp)
  local tc=g:GetFirst()
  if tc and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 then
      local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			tc:RegisterFlagEffect(7156,RESET_EVENT+0x1fe0000,0,1)
			Duel.SpecialSummonComplete()
  end
end

function c7156.fstg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then
    local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
    return Duel.IsExistingMatchingCard(c7156.fsfil1,tp,LOCATION_MZONE,0,1,nil,e,tp,chkf)
  end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c7156.fsfil1(c,e,tp,chkf)
  if c:GetFlagEffect(7156)>0 then
    local mg1=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,LOCATION_HAND+LOCATION_MZONE,0,c)
    local res=Duel.IsExistingMatchingCard(c7156.fsfil2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,c,nil,chkf)
    if not res then
      local ce=Duel.GetChainMaterial(tp)
      if ce~=nil then
        local fgroup=ce:GetTarget()
        local mg2=fgroup(ce,e,tp)
        local mf=ce:GetValue()
        res=Duel.IsExistingMatchingCard(c7156.fsfil2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,c,mf,chkf)
      end
    end
    return res
  else return false end
end
function c7156.fsfil2(c,e,tp,m,ec,f,chkf)
  return c:IsType(TYPE_FUSION) and c:IsRace(RACE_FIEND) and (not f or f(c)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,ec,chkf)
end
function c7156.fsfil3(c,e,tp,chkf)
  return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e) and c7156.fsfil1(c,e,tp,chkf)
end
function c7156.fsop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if not c:IsRelateToEffect(e) then return end
  local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
  --To be completed
end

function c7156.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c7156.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2000)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,0,0,tp,2000)
end
function c7156.damop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
