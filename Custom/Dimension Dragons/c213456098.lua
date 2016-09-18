--覇王新竜G・O・D
--Genesis Omega Dragon
--Manga original, altered and scripted by Eerie Code
function c213456098.initial_effect(c)
	aux.EnablePendulumAttribute(c,false)
	--cannot disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_FUSION+TYPE_RITUAL+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM))
	c:RegisterEffect(e1)
	--Summon Materials
	c:EnableReviveLimit()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetLabelObject(ea)
	e2:SetCondition(c213456098.spcon)
	e2:SetOperation(c213456098.spop)
	c:RegisterEffect(e2)
	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
end

--Setcode filters
function c213456098.fd(c)
	return c:IsCode(41209827) or (c:IsSetCard(0x46) and c:IsSetCard(0xee0))
end
function c213456098.rd(c)
	return c:IsSetCard(0x2ee0)
end
function c213456098.sd(c)
	return c:IsCode(82044279,50954680) or c:IsSetCard(0x1ee0)
end
function c213456098.xd(c)
	return c:IsCode(16195942,1621413) or (c:IsSetCard(0x73) and c:IsSetCard(0xee0))
end
function c213456098.pd(c)
	return c:IsSetCard(0xf1)
end
function c213456098.oddeyes(c)
	return c:IsCode(16178681)
end

function c213456098.tribute(c,tp,st)
	if c:IsFacedown() and not c:IsControler(tp) then return end
	if not c:IsReleasable() then return end
	if st==TYPE_FUSION then
		return c213456098.fd(c)
	elseif st==TYPE_RITUAL then
		return c213456098.rd(c)
	elseif st==TYPE_SYNCHRO then
		return c213456098.sd(c)
	elseif st==TYPE_XYZ then
		return c213456098.xd(c)
	elseif st==TYPE_PENDULUM then
		return c213456098.oddeyes(c)
	else
		return false
	end
end
function c213456098.spcon(e,c)
	if c==nil then return true end
	if c:IsFaceup() then return false end
	local tp=c:GetControler()
	local tys={TYPE_FUSION,TYPE_RITUAL,TYPE_SYNCHRO,TYPE_XYZ,TYPE_PENDULUM}
	local ct=0
	local g=Duel.GetReleaseGroup(tp)
	g:Merge(Duel.GetReleaseGroup(1-tp))
	for i,v in ipairs(tys) do
		if Duel.CheckReleaseGroup(tp,c213456098.tribute,1,nil,v) then ct=ct+1 end
	end
	return ct>=4
end
