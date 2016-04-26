--Kaiju Limit Condition
function Auxiliary.AddKaijuLimitCondition(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(Auxiliary.KaijuAdjustOperation())
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(Auxiliary.KaijuSummonLimit())
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	c:RegisterEffect(e4)
	local g=Group.CreateGroup()
	g:KeepAlive()
	e1:SetLabelObject(g)
end
function Auxiliary.KaijuAdjustFilter(c,g,pg)
	if pg:IsContains(c) then return false end
	return g:IsExists(Card.IsSetCode,1,c,0xd3) or pg:IsExists(Card.IsSetCode,1,c,0xd3)
end
function Auxiliary.KaijuAdjustOperation()
	return function(e,tp,eg,ep,ev,re,r,rp)
		local phase=Duel.GetCurrentPhase()
		if (phase==PHASE_DAMAGE and not Duel.IsDamageCalculated()) or phase==PHASE_DAMAGE_CAL then return end
		local c=e:GetHandler()
		local pg=e:GetLabelObject()
		local flag=e:GetCode()
		if c:GetFlagEffect(flag)==0 then
			c:RegisterFlagEffect(flag,RESET_EVENT+0x1ff0000,0,1)
			pg:Clear()
		end
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
		local dg=g:Filter(Auxiliary.KaijuAdjustFilter,nil,g,e:GetLabelObject())
		if dg:GetCount()==0 or Duel.Destroy(dg,REASON_EFFECT)==0 then
			pg:Clear()
			pg:Merge(g)
			pg:Sub(dg)
		else
			g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
			pg:Clear()
			pg:Merge(g)
			pg:Sub(dg)
			Duel.Readjust()
		end
	end
end
function Auxiliary.KaijuSummonFilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd3)
end
function Auxiliary.KaijuSummonLimit()
	return function(e,c,sump,sumtype,sumpos,targetp)
		return c:IsSetCard(0xd3) and (targetp==c:GetControler() or Duel.IsExistingMatchingCard(Auxiliary.KaijuSummonFilter,targetp,LOCATION_MZONE,0,1,nil))
	end
end
