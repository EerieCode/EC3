--Scripted by Eerie Code
--Magician's Robe
function c7119.initial_effect(c)
  --Special Summon (DM)
  local e1=Effect.CreateEffect(c)
  e1:SetDescription(aux.Stringid(7119,0))
  e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e1:SetType(EFFECT_TYPE_QUICK_O)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetCountLimit(1,7119)
  e1:SetCondition(c7119.spcon)
  e1:SetCost(c7119.spcost)
  e1:SetTarget(c7119.sptg)
  e1:SetOperation(c7119.spop)
  c:RegisterEffect(e1)
  --Special Summon (Self)
  local e2=Effect.CreateEffect(c)
  c:RegisterEffect(e2)
end

function c7119.spcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.GetTurnPlayer()~=tp
end
function c7119.cfilter(c)
  return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDiscardable()
end
function c7119.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(c7119.cfilter,tp,LOCATION_HAND,0,1,nil) end
  Duel.DiscardHand(tp,c7119.cfilter,1,1,REASON_COST+REASON_DISCARD)
end
function c7119.spfil(c,e,tp)
  return c:IsCode(46986414) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c7119.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c7119.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c7119.spop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
  local g=Duel.SelectMatchingCard(tp,c7119.spfil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
  if g:GetCount()>0 then
    Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
  end
end
