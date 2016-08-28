--輪廻の魔術師
--Samsara Magician
--Created and scripted by Eerie Code
function c213456025.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,213456025)
	e1:SetCategory(CATEGORY_LVCHANGE+CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTarget(c213456025.lvtg)
	e1:SetOperation(c213456025.lvop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c213456025.thcon)
	e2:SetCost(c213456025.thcost)
	e2:SetTarget(c213456025.thtg)
	e2:SetOperation(c213456025.thop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1002,1))
	e3:SetCategory(CATEGORY_LVCHANGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,213456025+1+EFFECT_COUNT_CODE_SINGLE)
	e3:SetCost(c213456025.lucost)
	e3:SetTarget(c213456025.lutg)
	e3:SetOperation(c213456025.luop)
	c:RegisterEffect(e3)
	--
	local e4=e3:Clone()
	e4:SetDescription(aux.Stringid(1002,2))
	e4:SetCategory(CATEGORY_LVCHANGE+CATEGORY_RECOVER)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCost(c213456025.ldcost)
	e4:SetTarget(c213456025.ldtg)
	e3:SetOperation(c213456025.ldop)
	c:RegisterEffect(e4)
end

function c213456025.lvfil(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c213456025.lvcfil(c,lv)
	return c:GetLevel()~=lv
end
function c213456025.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c213456025.lvfil,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g:GetCount()>0 end
	local t={}
	local i=1
	local p=1
	for i=1,3 do
		if g:FilterCount(c213456025.lvcfil,nil,i)>0 then t[p]=i p=p+1 end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,567)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c213456025.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c213456025.splimit)
	Duel.RegisterEffect(e1,tp)
	if not c:IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetMatchingGroup(c213456025.lvfil,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	local dif=0
	local lv=e:GetLabel()
	while tc do
		dif=math.max(dif,math.abs(tc:GetLevel()-lv))
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	if dif>0 then
		Duel.Recover(p,dif*500,REASON_EFFECT)
	end
end
function c213456025.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsLocation(LOCATION_EXTRA)
end

function c213456025.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg and eg:GetCount()==1 and eg:GetFirst()==c and c:IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c213456025.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,nil,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c213456025.thfil(c)
	return c:IsSetCard(0x98) and c:IsType(TYPE_PENDULUM) and (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE)) and c:IsAbleToHand()
end
function c213456025.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c213456025.thfil,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c213456025.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c213456025.thfil,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c213456025.lucost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	local lp=Duel.GetLP(tp)
	local ct=math.floor((lp-1)/500)
	local t={}
	for i=1,ct do
		t[i]=i*500
	end
	local cost=Duel.AnnounceNumber(tp,table.unpack(t))
	Duel.PayLPCost(tp,cost)
	e:SetLabel(math.floor(cost/500))
end
function c213456025.lufil(c)
	return c:IsFaceup() and c:IsLevelAbove(1)
end
function c213456025.lutg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c213456025.lufil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c213456025.lufil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c213456025.lufil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c213456025.luop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local lv=e:GetLabel()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end

function c213456025.ldcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
end
function c213456025.ldfil(c)
	return c:IsFaceup() and c:IsLevelAbove(2)
end
function c213456025.ldtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c213456025.ldfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c213456025.ldfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c213456025.ldfil,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local t={}
	local p=tc:GetLevel()-1
	p=math.min(p,5)
	for i=1,p do
		t[i]=i
	end
	Duel.Hint(HINT_SELECTMSG,tp,567)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,0)
end
function c213456025.ldop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local lv=math.min(tc:GetLevel(),e:GetLabel())
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(-lv)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		Duel.Recover(p,lv*500,REASON_EFFECT)
	end
end
