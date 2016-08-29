--ＷＷの至点
--Solstice of the Wind Witch
--Created by ScarletKing, scripted by Eerie Code
function c215558063.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_END_PHASE)
	e1:SetCountLimit(1,215558063)
	e1:SetOperation(c215558063.activate)
	c:RegisterEffect(e1)
	if c215558063.counter==nil then
		c215558063.counter=true
		c215558063[0]=0
		c215558063[1]=0
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e2:SetOperation(c215558063.resetcount)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e3:SetCode(EVENT_DAMAGE)
		e3:SetOperation(c215558063.addcount)
		Duel.RegisterEffect(e3,0)
	end
end
function c215558063.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c215558063[0]=0
	c215558063[1]=0
end
function c215558063.addcount(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if bit.band(r,REASON_EFFECT)~=0 and ep~=tp and rc and rc:IsSetCard(0xf0) then
		c215558063[rp]=c215558063[rp]+1
	end
end
function c215558063.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c215558063.droperation)
	Duel.RegisterEffect(e1,tp)
end
function c215558063.droperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,215558063)
	Duel.Draw(tp,c215558063[tp],REASON_EFFECT)
end
