--Scripted by Eerie Code
--Meteor Houkai Device Duja
function c6125.initial_effect(c)
  --Send to Grave
  local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(6125,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_SUMMON_SUCCESS)
	e3:SetTarget(c6125.tgtg)
	e3:SetOperation(c6125.tgop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--Increase ATK
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(6125,1))
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c6125.atkcon)
	e5:SetTarget(c6125.atktg)
	e5:SetOperation(c6125.atkop)
	c:RegisterEffect(e5)
end

function c6125.tgfilter(c)
	return c:IsSetCard(0xe5) and c:IsAbleToGrave()
end
function c6125.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6125.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c6125.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c6125.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end

function c6125.atkcfil(c,tid)
  return c:IsType(TYPE_MONSTER) and c:GetTurnId()==tid and not c:IsReason(REASON_RETURN)
end
function c6125.atkcon(e,tp,eg,ep,ev,re,r,rp)
  return Duel.IsExistingMatchingCard(c6125.atkcfil,tp,LOCATION_GRAVE,0,1,nil,Duel.GetTurnCount())
end
function c6125.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_GRAVE,0,1,nil,TYPE_MONSTER) end
end
function c6125.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  local mc=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER):GetClassCount(Card.GetCode)
  if not c:IsLocation(LOCATION_MZONE) or not c:IsFaceup() or mc==0 then return end
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_UPDATE_ATTACK)
  e1:SetValue(200*mc)
  e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
  c:RegisterEffect(e1)
end

