--十二獣ライカ
--Zoodiac Lyca
--Scripted by Eerie Code
function c100912047.initial_effect(c)
  --xyz summon
	aux.AddXyzProcedure(c,nil,4,2,c100912047.ovfilter,aux.Stringid(100912047,0),5,c100912047.xyzop)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c100912047.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c100912047.defval)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(100912047,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1)
	e3:SetCost(c100912047.spcost)
	e3:SetTarget(c100912047.sptg)
	e3:SetOperation(c100912047.spop)
	c:RegisterEffect(e3)
end
function c100912047.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xf1) and not c:IsCode(100912047)
end
function c100912047.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,100912047)==0 end
	Duel.RegisterFlagEffect(tp,100912047,RESET_PHASE+PHASE_END,0,1)
end
function c100912047.atkfilter(c)
	return c:IsSetCard(0xf1) and c:GetAttack()>=0
end
function c100912047.atkval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c100912047.atkfilter,nil)
	return g:GetSum(Card.GetAttack)
end
function c100912047.deffilter(c)
	return c:IsSetCard(0xf1) and c:GetDefense()>=0
end
function c100912047.defval(e,c)
	local g=e:GetHandler():GetOverlayGroup():Filter(c100912047.deffilter,nil)
	return g:GetSum(Card.GetDefense)
end
function c100912047.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c100912047.spfilter(c,e,tp)
	return c:IsSetCard(0xf1) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
