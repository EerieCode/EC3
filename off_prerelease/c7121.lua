--Scripted by Eerie Code
--Magician's Rod
function c7121.initial_effect(c)
  --Search
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(7121,0))
  e1:SetCategory(CATEGORY_TOHAND)
  e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e1:SetCode(EVENT_SUMMON_SUCCESS)
  e1:SetCountLimit(1,7121)
  e1:SetTarget(c7121.thtg)
  e1:SetOperation(c7121.thop)
  c:RegisterEffect(e1)
  --Recover
end

function c7121.thfil(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP) and c.dark_magician_list and c:IsAbleToHand()
end
function c7121.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c7121.thfil,tp,LOCATION_DECK,0,1,nil) end
  Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c7121.thop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
  local g=Duel.SelectMatchingCard(tp,c7121.thfil,tp,LOCATION_DECK,0,1,1,nil)
  if g:GetCount()>0 then
    Duel.SendtoHand(g,tp,REASON_EFFECT)
  end
end

