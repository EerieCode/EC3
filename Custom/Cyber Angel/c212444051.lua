--リチューアル・リプレイ
--Ritual Replay
--Created and scripted by Eerie Code
function c212444051.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,212444051+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c212444051.cost)
	e1:SetTarget(c212444051.target)
	e1:SetOperation(c212444051.operation)
	c:RegisterEffect(e1)
end

function c212444051.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c212444051.filter(c)
	return c:GetType()==TYPE_SPELL+TYPE_RITUAL and c:CheckActivateEffect(true,true,false)~=nil and c:GetTurnId()==Duel.GetTurnCount() and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c212444051.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then
		local te=e:GetLabelObject()
		local tg=te:GetTarget()
		return tg(e,tp,eg,ep,ev,re,r,rp,0,chkc)
	end
	if chk==0 then
		if e:GetLabel()==0 then return false end
		e:SetLabel(0)
		return Duel.CheckLPCost(tp,600) and Duel.IsExistingMatchingCard(c212444051.filter,tp,LOCATION_GRAVE,0,1,nil)
	end
	e:SetLabel(0)
	Duel.PayLPCost(tp,600)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,c212444051.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	local te=g:GetFirst():CheckActivateEffect(true,true,false)
	e:SetLabelObject(te)
	Duel.HintSelection(g)
	e:SetCategory(te:GetCategory())
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
end
function c212444051.operation(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
