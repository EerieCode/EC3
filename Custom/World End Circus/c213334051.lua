--World's End Circus - Sleight of Hand
--Created by Drakylon
--Scripted by Eerie Code
function c213334051.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PREDRAW)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c213334051.condition)
	e2:SetTarget(c213334051.target)
	e2:SetOperation(c213334051.operation)
	c:RegisterEffect(e2)
end

function c213334051.condition(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and Duel.GetDrawCount(tp)>0
end
function c213334051.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return true end
	if g:GetCount()==0 then e:SetLabel(1)
	else
		local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
		if tc:IsFaceup() then
			e:SetLabel(1)
			return
		end
		e:SetLabel(0)
		local dt=Duel.GetDrawCount(tp)
		if dt~=0 then
			_replace_count=0
			_replace_max=dt
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
			e1:SetCode(EFFECT_DRAW_COUNT)
			e1:SetTargetRange(1,0)
			e1:SetReset(RESET_PHASE+PHASE_DRAW)
			e1:SetValue(0)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function c213334051.operation(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==1 then
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	else
		_replace_count=_replace_count+1
		if _replace_count>_replace_max or not e:GetHandler():IsRelateToEffect(e) then return end
		local g=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,0,nil)
		if g:GetCount()==0 then 
			Duel.Destroy(e:GetHandler(),REASON_RULE)
			return
		end
		local tc=g:GetMinGroup(Card.GetSequence):GetFirst()
		Duel.SendtoHand(tc,tp,REASON_DRAW+REASON_RULE)
	end
end
