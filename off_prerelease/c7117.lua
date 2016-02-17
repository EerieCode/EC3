--Scripted by Eerie Code
--Magician of Black Illusion
function c7117.initial_effect(c)
  --Name change
  local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(46986414)
	c:RegisterEffect(e1)
  --Special Summon (self)
  local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_HAND)
	e2:SetOperation(c7117.spsreg)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7117,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCountLimit(1,7117)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c7117.spscon)
	e3:SetTarget(c7117.spstg)
	e3:SetOperation(c7117.spsop)
	c:RegisterEffect(e3)
  --Special Summon (DM)
end

function c7117.spsreg(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(7117)==0 then
		e:GetHandler():RegisterFlagEffect(7117,RESET_EVENT+0x1fc0000+RESET_CHAIN,0,1)
	end
end

function c7117.spscon(e,tp,eg,ep,ev,re,r,rp)
	local c=re:GetHandler()
	return rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and c:IsType(TYPE_SPELL+TYPE_TRAP) and Duel.GetTurnPlayer()~=tp and e:GetHandler():GetFlagEffect(1)>0
end
function c7117.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
  local c=e:GetHandler()
  if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
  Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c7117.spsop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
    Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
  end
end
