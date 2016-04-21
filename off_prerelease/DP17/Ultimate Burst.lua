--アルティメット・バースト
--Ultimate Burst
--Scripted by Eerie Code
function c7077.initial_effect(c)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetCondition(c7077.con)
  e1:SetTarget(c7077.tg)
  e1:SetOperation(c7077.op)
  c:RegisterEffect(e1)
end

function c7077.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c7077.fil(c)
  return c:IsFaceup() and c:IsCode(23995346) and bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and not c:IsHasEffect(EFFECT_EXTRA_ATTACK)
end
function c7077.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c7077.fil(chkc) end
  if chk==0 then return Duel.IsExistingTarget(c7077.fil,tp,LOCATION_MZONE,0,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  Duel.SelectTarget(tp,c7077.fil,tp,LOCATION_MZONE,0,1,1,nil)
end

