--蒼穹の機界騎士
--Mekk-Knight of the Blue Sky
--Scripted by Eerie Code
function c101003014.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,65100616)
	e1:SetCondition(c101003014.spcon)
	e1:SetValue(c101003014.spval)
	c:RegisterEffect(e1)
end
function c101003014.cfilter(c,seq)
	local s=c:GetSequence()
	return s==seq or (seq==1 and s==5) or (seq==3 and s==6)
end
function c101003014.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local zone=0
	for i=0,4 do
		if Duel.GetMatchingGroupCount(c101003014.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,i)>=2 then
			zone=zone+math.pow(2,i)
		end
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE,tp,LOCATION_REASON_TOFIELD,zone)>0
end
function c101003014.spval(e,c)
	local zone=0
	for i=0,4 do
		if Duel.GetMatchingGroupCount(c101003014.cfilter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil,i)>=2 then
			zone=zone+math.pow(2,i)
		end
	end
	return 0,zone
end
