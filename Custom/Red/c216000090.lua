--レッド・ルール
--Red Rule
--Created by ScarletKing, scripted by Eerie Code
function c216000090.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,216000090)
	e1:SetCondition(c216000090.condition)
	e1:SetTarget(c216000090.target)
	e1:SetOperation(c216000090.activate)
	c:RegisterEffect(e1)
end
c216000090.red_daemons_list=true

function c216000090.cfil(c)
	return not (c:IsFaceup() and c:IsSetCard(0x1045) and c:IsType(TYPE_SYNCHRO))
end
function c216000090.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0 and not Duel.IsExistingMatchingCard(c216000090.cfil,tp,LOCATION_MZONE,0,1,nil)
end
function c216000090.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c216000090.fil(c)
	return c:IsFaceup() and c:IsSetCard(0x1045) and c:IsType(TYPE_SYNCHRO) and bit.band(c:GetSummonType(),SUMMON_TYPE_SYNCHRO)==SUMMON_TYPE_SYNCHRO
end
function c216000090.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
		local g=Duel.GetMatchingGroup(c216000090.fil,tp,LOCATION_MZONE,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(1009,0)) then
			local sg=g:Select(tp,1,1,nil)
			local sc=sg:GetFirst()
			local d=sc:GetMaterial():FilterCount(Card.IsType,nil,TYPE_TUNER)
			Duel.Draw(tp,d,REASON_EFFECT)
		end
	end
end
