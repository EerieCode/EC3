--World’s End Circus - Banishing Magician
--Created by Drakylon
--Scripted by Eerie Code
function c213334036.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,3,2)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c213334036.xyzcon)
	e1:SetTarget(c213334036.xyztg)
	e1:SetOperation(c213334036.xyzop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(TIMING_BATTLE_PHASE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c213334036.rmcon)
	e2:SetTarget(c213334036.rmtg)
	e2:SetOperation(c213334036.rmop)
	c:RegisterEffect(e2)
end

function c213334036.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayCount()==0
end
function c213334036.matfil(c,e)
	return c:IsSetCard(0xedc) and not c:IsImmuneToEffect(e)
end
function c213334036.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c213334036.matfil,tp,LOCATION_HAND,0,1,nil,e) end
end
function c213334036.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local g=Duel.SelectMatchingCard(tp,c213334036.matfil,tp,LOCATION_HAND,0,1,1,nil,e)
	if g:GetCount()>0 then
		Duel.Overlay(tc,g)
	end
end

function c213334036.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE and not e:GetHandler():IsStatus(STATUS_CHAINING) and e:GetHandler():GetOverlayCount()>0
end
function c213334036.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc and bc:IsOnField() and c:IsAbleToRemove() and bc:IsAbleToRemove() end
	local g=Group.FromCards(c,bc)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,2,0,POS_FACEDOWN+POS_FACEUP)
end
function c213334036.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetBattleTarget()
	if not c:IsRelateToBattle() or not tc:IsRelateToBattle() then return end
	if Duel.Remove(c,0,REASON_EFFECT+REASON_TEMPORARY)>0 then
		local og=Duel.GetOperatedGroup()
		local oc=og:GetFirst()
		oc:RegisterFlagEffect(213334036,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		og:KeepAlive()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetLabelObject(og)
		e1:SetOperation(c213334036.retop)
		Duel.RegisterEffect(e1,tp)
		Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT)
	end
end
function c213334036.retfilter(c)
	return c:GetFlagEffect(213334036)~=0
end
function c213334036.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	local sg=g:Filter(c213334036.retfilter,nil)
	g:DeleteGroup()
	local tc=sg:GetFirst()
	while tc do
		Duel.ReturnToField(tc)
		tc=sg:GetNext()
	end
end
