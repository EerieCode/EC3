--魔界台本 「ワイルド・ウエスト・シューティング」
--Abyss Script - Wild West Shooting
--Created and scripted by Eerie Code
function c216444035.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,216444035+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c216444035.con)
	e1:SetTarget(c216444035.tg)
	e1:SetOperation(c216444035.op)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c216444035.atkcon)
	e2:SetTarget(c216444035.atktg)
	e2:SetOperation(c216444035.atkop)
	c:RegisterEffect(e2)
end

function c216444035.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c216444035.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x10ec)
end
function c216444035.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c216444035.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c216444035.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c216444035.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c216444035.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(81927732,0))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_ATTACK_ALL)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end

function c216444035.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN) and Duel.IsExistingMatchingCard(c216444035.filter,tp,LOCATION_EXTRA,0,1,nil)
end
function c216444035.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c216444035.atkop(e,tp,eg,ep,ev,re,r,rp)
	local de=0
	if EFFECT_SET_DEFENSE_FINAL then de=EFFECT_SET_DEFENSE_FINAL else de=EFFECT_SET_DEFENCE_FINAL end
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(math.floor(tc:GetAttack()/2))
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(de)
		if Card.GetDefense then
			e2:SetValue(math.floor(tc:GetDefense()/2))
		else
			e2:SetValue(math.floor(tc:GetDefence()/2))
		end
		tc:RegisterEffect(e2)
		tc=g:GetNext()
	end
end
