--究極変異態・インセクト女王
--Ultimately Mutated Insect Queen
--Scripted by Eerie Code
function c100419008.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c100419008.splimit)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c100419008.indcon)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_INSECT))
	e2:SetValue(c100419008.indval)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c100419008.indcon)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_INSECT))
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
function c100419008.splimit(e,se,sp,st)
	return se
end
function c100419008.indfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_INSECT)
end
function c100419008.indcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c100419008.indfilter,tp,LOCATION_MZONE,0,1,e:GetHandler())
end
function c100419008.indval(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
