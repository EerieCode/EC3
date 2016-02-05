--Scripted by Eerie Code
--Dragon Knight of Creation
function c6119.initial_effect(c)
  --Level
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_LEVEL)
  e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
  e1:SetRange(LOCATION_MZONE)
  e1:SetValue(4)
  e1:SetCondition(c6119.lvcon)
  c:RegisterEffect(e1)
  --Send to grave
  local e2=Effect.CreateEffect(c)
  e2:SetCategory(CATEGORY_TOGRAVE)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e2:SetCode(EVENT_BATTLE_DESTROYING)
  e2:SetCondition(aux.bdocon)
  e2:SetTarget(c6119.tgtg)
  e2:SetOperation(c6119.tgop)
  c:RegisterEffect(e2)
end

function c6119.lvcon(e)
  return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end

function c6119.tgfil(c)
  return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_DRAGON) and (c:GetLevel()==7 or c:GetLevel()==8) and c:IsAbleToGrave()
end
function c6119.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c6119.tgfil,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,0,0)
end
function c6119.tgop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
  local g=Duel.SelectMatchingCard(tp,c6119.tgfil,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoGrave(g,REASON_EFFECT)
  end
end
