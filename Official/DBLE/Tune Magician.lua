--調弦の魔術師
--Tune Magician
--Scripted by Eerie Code
function c7652.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetRange(LOCATION_PZONE)
	e1:SetValue(c7652.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetRange(LOCATION_EXTRA)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(aux.FALSE)
	c:RegisterEffect(e3)
end

function c7652.atkfil(c)
	return c:IsFaceup() and c:IsType(TYPE_PENDULUM) and c:IsSetCard(SET_MAGICIAN)
end
function c7652.atkval(e,c)
	return Duel.GetMatchingGroupCount(c7652.atkfil,tp,LOCATION_EXTRA,0,nil)*100
end
