--覇王門零
--Supreme King Gate Zero
--Scripted by Eerie Code
function c100912017.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--avoid damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_AVAILABLE_BD)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c100912017.ndcon)
	e1:SetValue(0)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100912017,0))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c100912017.thcon)
	e2:SetTarget(c100912017.thtg)
	e2:SetOperation(c100912017.thop)
	c:RegisterEffect(e2)
end
function c100912017.ndcfilter(c)
	return c:IsFaceup() and c:IsCode(100912039)
end
function c100912017.ndcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100912018.ndcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c100912017.thcon(e,tp,eg,ep,ev,re,r,rp)
	local seq=e:GetHandler():GetSequence()
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-seq)
	return pc and pc:IsCode(100912018)
end
function c100912017.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x46) and c:IsAbleToHand()
end
