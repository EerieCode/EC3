--重装甲列車アイアン・ヴォルフ
--Heavy-Armored Train Iron Wolf
--Scripted by Eerie Code
function c7550.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),4,2)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7550,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetCondition(c7550.con)
	e1:SetCost(c7550.cost)
	e1:SetTarget(c7550.tg)
	e1:SetOperation(c7550.op)
	c:RegisterEffect(e1)
end

function c7550.con(e)
	return Duel.GetCurrentPhase()==PHASE_MAIN1
end
function c7550.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCost(tp,1,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c7550.fil(c)
	return c:IsFaceup() and c:GetEffectCount(EFFECT_DIRECT_ATTACK)==0 and c:IsRace(RACE_MACHINE)
end
function c7550.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c7550.fil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c7550.fil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c7550.fil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c7550.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local fid=tc:GetFieldID()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c7550.atktg)
		e1:SetLabel(fid)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DIRECT_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
	end
end
function c7550.atktg(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
