--幻影騎士団フォールキング
--Fallen King of the Phantom Knights
--Created and scripted by Eerie Code
function c216666045.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCondition(c216666045.xyzcon)
	e0:SetOperation(c216666045.xyzop)
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--mat check
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c216666045.valcheck)
	--c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c216666045.regcon)
	e2:SetOperation(c216666045.regop)
	c:RegisterEffect(e2)
	--e2:SetLabelObject(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCost(c216666045.cpcost)
	e3:SetTarget(c216666045.cptg)
	e3:SetOperation(c216666045.cpop)
	c:RegisterEffect(e3)
end

function c216666045.mfilter(c,xyzc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0x10db) and c:IsCanBeXyzMaterial(xyzc)
end
function c216666045.xyzfilter1(c,g,ct)
	return g:IsExists(c216666045.xyzfilter2,ct,c,c:GetRank())
end
function c216666045.xyzfilter2(c,rk)
	return c:GetRank()==rk
end
function c216666045.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local minc=2
	local maxc=64
	if min then
		minc=math.max(minc,min)
		maxc=max
	end
	local ct=math.max(minc-1,-ft)
	local mg=nil
	if og then
		mg=og:Filter(c216666045.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c216666045.mfilter,tp,LOCATION_MZONE,0,nil,c)
	end
	return maxc>=2 and mg:IsExists(c216666045.xyzfilter1,1,nil,mg,ct)
end
function c216666045.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local g=nil
	if og and not min then
		g=og
	else
		local mg=nil
		if og then
			mg=og:Filter(c216666045.mfilter,nil,c)
		else
			mg=Duel.GetMatchingGroup(c216666045.mfilter,tp,LOCATION_MZONE,0,nil,c)
		end
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local minc=2
		local maxc=64
		if min then
			minc=math.max(minc,min)
			maxc=max
		end
		local ct=math.max(minc-1,-ft)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		g=mg:FilterSelect(tp,c216666045.xyzfilter1,1,1,nil,mg,ct)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=mg:FilterSelect(tp,c216666045.xyzfilter2,ct,maxc-1,g:GetFirst(),g:GetFirst():GetRank())
		g:Merge(g2)
	end
	local sg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		sg:Merge(tc:GetOverlayGroup())
		tc=g:GetNext()
	end
	Duel.SendtoGrave(sg,REASON_RULE)
	c:SetMaterial(g)
	Duel.Overlay(c,g)
end

function c216666045.valfil(c)
	return c:IsType(TYPE_XYZ) and c:IsSetCard(0x10db)
end
function c216666045.valcheck(e,c)
	local g=c:GetOverlayGroup():Filter(c216666045.valfil,nil)
	local rk=0
	local tc=g:GetFirst()
	while tc do
		rk=rk+tc:GetRank()
		tc=g:GetNext()
	end
	e:SetLabel(rk)
end
function c216666045.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c216666045.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	--local rk=e:GetLabel()
	local g=c:GetOverlayGroup():Filter(c216666045.valfil,nil)
	local rk=0
	local tc=g:GetFirst()
	while tc do
		rk=rk+tc:GetRank()
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(rk*300)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
end

function c216666045.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,600) end
	Duel.PayLPCost(tp,600)
end
function c216666045.cpfil(c)
	return bit.band(c:GetOriginalAttribute(),ATTRIBUTE_DARK)==ATTRIBUTE_DARK
end
function c216666045.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local og=e:GetHandler():GetOverlayGroup()
	if chk==0 then return og:IsExists(c216666045.cpfil,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local sg=og:FilterSelect(tp,c216666045.cpfil,1,1,nil)
	local tc=sg:GetFirst()
	Duel.Hint(HINT_CARD,0,tc:GetCode())
	e:SetLabelObject(tc)
	Duel.SetTargetCard(tc)
end
function c216666045.cpop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local code=tc:GetOriginalCodeRule()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CHANGE_CODE)
		e1:SetValue(code)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		if not tc:IsType(TYPE_TRAPMONSTER) then
			c:CopyEffect(code,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
		end
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetLabel(tc:GetFieldID())
		e2:SetLabelObject(c)
		e2:SetCountLimit(1)
		e2:SetOperation(c216666045.detop)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c216666045.detfil(c,id)
	return c:GetFieldID()==id
end
function c216666045.detop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetLabelObject()
	local id=e:GetLabel()
	if c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:GetOverlayCount()>0 then
		local g=c:GetOverlayGroup():Filter(c216666045.detfil,nil)
		if g:GetCount()==0 then return end
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
