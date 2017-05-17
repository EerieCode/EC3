--メタファイズ・ラグナロク
--Metaphys Ragnarok
--Scripted by Eerie Code
function c101002023.initial_effect(c)
	--banish and increase atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101002023,0))
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,101002023)
	e1:SetTarget(c101002023.rmtg)
	e1:SetOperation(c101002023.rmop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
end
function c101002023.rmfilter(c)
	return c:IsCode(89189982,36898537) or c:IsSetCard(0x202)
end
function c101002023.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rg=Duel.GetDecktopGroup(tp,3)
	if chk==0 then return rg:FilterCount(Card.IsAbleToRemove,nil)==3 end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,3,0,0)
end
function c101002023.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()==3 and Duel.Remove(g,POS_FACEUP,REASON_EFFECT)==3 
		and c:IsFaceup() and c:IsRelateToEffect(e) then
		local og=Duel.GetOperatedGroup()
		local oc=og:FilterCount(c101002023.rmfilter,nil)
		if oc==0 then return end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(oc*300)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
end
