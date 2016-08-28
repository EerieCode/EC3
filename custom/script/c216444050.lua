--魔界舞台「七福神の宝船」
--Abyss Stage - Treasure Ship of the Seven Lucky Gods
--Anime original, altered and scripted by Eerie Code
function c216444050.initial_effect(c)
	c:SetUniqueOnField(1,1,0x40ec)
	c:EnableCounterPermit(0x160) --Face
	c:EnableCounterPermit(0x161) --Heel
	c:SetCounterLimit(0x160,c216444050.max_counter)
	c:SetCounterLimit(0x161,c216444050.max_counter)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,216444050+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c216444050.actop)
	c:RegisterEffect(e1)
	--Board (turn player)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE+CATEGORY_DESTROY+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_BOTH_SIDE+EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCondition(c216444050.ctcon)
	e2:SetTarget(c216444050.cttg)
	e2:SetOperation(c216444050.ctop)
	c:RegisterEffect(e2)
	--Extra Draw
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_DRAW_COUNT)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE) 
	e3:SetTargetRange(1,1)
	e3:SetValue(c216444050.drawval)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetOperation(c216444050.tgop)
	c:RegisterEffect(e4)
	if c216444050.global_count==nil then
		c216444050[0]=1
		c216444050[1]=1
	end
end

c216444050.max_counter=2

function c216444050.actop(e,tp,eg,ep,ev,re,r,rp)
	c216444050[tp]=Duel.GetDrawCount(tp)
	c216444050[1-tp]=Duel.GetDrawCount(1-tp)
end

function c216444050.ctcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()==tp then
		return c:GetCounter(0x160)<c216444050.max_counter
	else
		return c:GetCounter(0x161)<c216444050.max_counter
	end
end
function c216444050.ctfil(c,tp,owner)
	return c:IsFaceup() and c:IsAbleToRemove(tp) and (not owner or c:IsSetCard(0x10ec))
end
function c216444050.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local owner=(c:GetControler()==tp)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c216444050.ctfil(chkc,tp,owner) end
	if chk==0 then return Duel.IsExistingTarget(c216444050.ctfil,tp,LOCATION_MZONE,0,1,nil,tp,owner) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c216444050.ctfil,tp,LOCATION_MZONE,0,1,1,nil,tp,owner)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	local dg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,0,g:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,dg:GetCount(),0,0)
	local ctr=0x161
	if owner then ctr=0x160 end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0,ctr)
end
function c216444050.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local ctr=0x161
	if c:GetControler()==tp then ctr=0x160 end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
		local og=Duel.GetOperatedGroup()
		og:GetFirst():RegisterFlagEffect(216444050,RESET_EVENT+0x1fe0000,0,1)
		local mg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,0,nil)
		if mg:GetCount()>0 then Duel.Destroy(mg,REASON_EFFECT) end
		c:AddCounter(ctr,1)
	end
end

function c216444050.drawval(e,c)
	local tp=Duel.GetTurnPlayer()
	local ctr=0x161
	if e:GetHandlerPlayer()==tp then ctr=0x160 end
	local ct=e:GetHandler():GetCounter(ctr)
	--local dc=Duel.GetDrawCount(tp)
	local dc=c216444050[tp]
	if not dc then return 1 end
	return dc+ct
end

function c216444050.tgfil(c)
	return c:GetFlagEffect(216444050)~=0
end
function c216444050.tgop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c216444050.tgfil,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	Duel.SendtoGrave(dg,REASON_RETURN)
end
