--魔界劇場でインプロヴィゼーション
--Improv Performance in the Abyss Theater
--Created and scripted by Eerie Code
function c216444075.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c216444075.con)
	e1:SetOperation(c216444075.op)
	c:RegisterEffect(e1)
end

function c216444075.cfil(c)
	return c:IsFaceup() and c:IsSetCard(0x10ec)
end
function c216444075.fil(c)
	return c:IsFacedown() and c:IsDestructable()
end
function c216444075.con(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	return ep~=tp and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and Duel.IsExistingMatchingCard(c216444075.cfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c216444075.fil,tp,LOCATION_SZONE,0,1,nil)
end
function c216444075.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Group.CreateGroup()
	Duel.ChangeTargetCard(ev,g)
	Duel.ChangeChainOperation(ev,c216444075.repop)
end
function c216444075.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():CancelToGrave(false)
	local g=Duel.GetMatchingGroup(c216444075.fil,tp,0,LOCATION_SZONE,nil)
	if g:GetCount()>0 then
		local sg=g:Select(tp,1,1,nil)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
