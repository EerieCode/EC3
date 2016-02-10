--Scripted by Eerie Code
--Performapal Dramatic Theater
function c7002.initial_effect(c)
  --Activate
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_ACTIVATE)
  e1:SetCode(EVENT_FREE_CHAIN)
  c:RegisterEffect(e1)
  --Increase ATK
  local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_PZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(c7002.value)
	c:RegisterEffect(e2)
  --Special Summon
  local e3=Effect.CreateEffect(c)
  c:RegisterEffect(e3)
end

function c7002.value(e,c)
  local tp=e:GetHandlerPlayer()
  local att=0
	for i=0,4 do
		local tc=Duel.GetFieldCard(tp,LOCATION_MZONE,i)
		if tc and tc:IsFaceup() then att=bit.bor(att,tc:GetRace()) end
	end
	local ct=0
	while att~=0 do
		if bit.band(att,0x1)~=0 then ct=ct+1 end
		att=bit.rshift(att,1)
	end
	return ct*200
end

