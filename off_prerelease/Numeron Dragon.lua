--Scripted by Eerie Code
--Number 100: Numeron Dragon
function c7271.initial_effect(c)
  --xyz summon
  c:EnableReviveLimit()
  local e1=Effect.CreateEffect(c)
  e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetCode(EFFECT_SPSUMMON_PROC)
  e1:SetRange(LOCATION_EXTRA)
  e1:SetCondition(c7271.xyzcon)
  e1:SetOperation(c7271.xyzop)
  e1:SetValue(SUMMON_TYPE_XYZ)
  c:RegisterEffect(e1)
  --Increase ATK
  local e2=Effect.CreateEffect(c)
  e2:SetDescription(aux.Stringid(7271,0))
  e2:SetCategory(CATEGORY_ATKCHANGE)
  e2:SetType(EFFECT_TYPE_IGNITION)
  e2:SetRange(LOCATION_MZONE)
  e2:SetCountLimit(1)
  e2:SetCost(c7271.atkcost)
  e2:SetOperation(c7271.atkop)
  c:RegisterEffect(e2)
  --Destroy and Set
  local e3=Effect.CreateEffect(c)
  e3:SetDescription(aux.Stringid(7271,1))
  e3:SetCategory(CATEGORY_DESTROY)
  e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
  e3:SetCode(EVENT_DESTROYED)
  e3:SetCondition(c7271.descon)
  e3:SetTarget(c7271.destg)
  e3:SetOperation(c7271.desop)
  --Special Summon
  local e4=Effect.CreateEffect(c)
  e4:SetDescription(aux.Stringid(7271,2))
  e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
  e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e4:SetCode(EVENT_ATTACK_ANNOUNCE)
  e4:SetRange(LOCATION_GRAVE)
  e4:SetCondition(c7271.spcon)
  e4:SetTarget(c7271.sptg)
  e4:SetOperation(c7271.spop)
  c:RegisterEffect(e4)
end
c7271.xyz_number=100
c7271.xyz_count=2

function c7271.mfilter(c,xyzc)
  return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x48) and c:IsCanBeXyzMaterial(xyzc)
end
function c7271.xyzfilter1(c,g)
  return g:IsExists(c7271.xyzfilter2,1,c,c)
end
function c7271.xyzfilter2(c,xc)
  return c:GetRank()==xc:GetRank() and c:GetCode()==xc:GetCode()
end
function c7271.xyzcon(e,c,og,min,max)
  if c==nil then return true end
  local tp=c:GetControler()
  local mg=nil
  if og then
    mg=og:Filter(c7271.mfilter,nil,c)
  else
    mg=Duel.GetMatchingGroup(c7271.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and (not min or min<=2 and max>=2)	and mg:IsExists(c7271.xyzfilter1,1,nil,mg)
end
function c7271.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
  local g=nil
  local sg=Group.CreateGroup()
  if og and not min then
    g=og
    local tc=og:GetFirst()
    while tc do
      sg:Merge(tc:GetOverlayGroup())
      tc=og:GetNext()
    end
  else
		local mg=nil
		if og then
			mg=og:Filter(c7271.mfilter,nil,c)
		else
			mg=Duel.GetMatchingGroup(c7271.mfilter,tp,LOCATION_MZONE,0,nil,c)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,c7271.xyzfilter1,1,1,nil,mg)
		local tc1=g:GetFirst()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=mg:FilterSelect(tp,c7271.xyzfilter2,1,1,tc1,tc1)
		local tc2=g2:GetFirst()
		g:Merge(g2)
		sg:Merge(tc1:GetOverlayGroup())
		sg:Merge(tc2:GetOverlayGroup())
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end

function c7271.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
  if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) end
  c:RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c7271.atkop(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local val=g:GetSum(Card.GetRank)*1000
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		c:RegisterEffect(e1)
	end
end

