--Scripted by Eerie Code
--Performapal Showdown
function c7005.initial_effect(c)
  local e1=Effect.CreateEffect(e1)
  e1:SetCategory(CATEGORY_POSITION)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
  e1:SetTarget(c7005.target)
  e1:SetOperation(c7005.operation)
end

function c7005.cfilter(c)
  return c:IsFaceup() and c:IsType(TYPE_SPELL)
end
function c7005.filter(c)
  return c:IsFaceup() and c:IsCanTurnSet()
end
function c7005.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
  local sc=Duel.GetMatchingGroupCount(c7005.cfilter,tp,LOCATION_ONFIELD,0,nil)
  if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c7005.filter(chkc) end
  if chk==0 then return sc>0 and Duel.IsExistingTarget(c7005.filter,tp,0,LOCATION_MZONE,1,nil) end
  Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
  local g=Duel.SelectTarget(tp,c7005.filter,tp,0,LOCATION_MZONE,1,sc,nil)
  Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c7005.operation(e,tp,eg,ep,ev,re,r,rp)
  local tg=Duel.GetChaininfo(0,CHAININFO_TARGET_CARDS)
  local tc=tg:GetFirst()
  while tc do
    if tc:IsRelateToEffect(e) and tc:IsFaceup() then
      Duel.ChangePosition(tc,POSITION_FACEDOWN_DEFENCE)
    end
    tc=tg:GetNext()
  end
end
