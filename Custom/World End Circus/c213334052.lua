--World's End Circus - Doomsday Gala
--Created by Drakylon
--Scripted by Eerie Code
function c213334052.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,213334052+EFFECT_COUNT_CODE_DUEL)
	e1:SetOperation(c213334052.regop)
	c:RegisterEffect(e1)
end

function c213334052.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(c213334052.countop)
	e1:SetReset(RESET_PHASE+PHASE_STANDBY)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetCondition(c213334052.rmcon)
	e2:SetOperation(c213334052.rmop)
	e2:SetReset(RESET_PHASE+PHASE_STANDBY)
	Duel.RegisterEffect(e2,tp)
	e1:SetLabelObject(e2)
end
function c213334052.countop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabelObject():GetLabel()
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0x1edc) then
			ct=ct+1
		end
		tc=eg:GetNext()
	end
	e:GetLabelObject():SetLabel(ct)
end
function c213334052.rmcon(e)
	local ct=e:GetLabel()
	return Duel.GetTurnPlayer()==e:GetHandlerPlayer() and ct>0 and Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>=ct and Duel.GetFieldGroupCount(tp,LOCATION_DECK)>=math.floor(ct/2) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,0,LOCATION_DECK,1,nil) and Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_DECK,0,1,nil)
end
function c213334052.rmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,213334052)
	local ct=e:GetLabel()
	local og=Duel.GetDecktopGroup(1-tp,ct)
	Duel.ConfirmCards(tp,og)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local rc=math.floor(ct)
	local rg=og:FilterSelect(Card.IsAbleToRemove,rc,rc,nil)
	if rg:GetCount()>0 then
		local rc2=Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
		local pg=Duel.GetDecktopGroup(tp,rc2)
		if pg:GetCount()>0 then
			Duel.Remove(pg,POS_FACEDOWN,REASON_EFFECT)
		end
	end
end
