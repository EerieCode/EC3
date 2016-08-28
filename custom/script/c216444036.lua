--魔界台本 「デビルファーザー」
--Abyss Script - The Devilfather
--Created and scripted by Eerie Code
function c216444036.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c216444036.op)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCondition(c216444036.dmcon)
	e2:SetTarget(c216444036.dmtg)
	e2:SetOperation(c216444036.dmop)
	c:RegisterEffect(e2)
end

function c216444036.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c216444036.aclimit)
	e1:SetCondition(c216444036.actcon)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c216444036.actfilter(c,tp)
	return c and c:IsSetCard(0x10ec) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function c216444036.aclimit(e,re,tp)
	return (re:IsHasType(EFFECT_TYPE_ACTIVATE) or re:IsActiveType(TYPE_MONSTER)) and not re:GetHandler():IsImmuneToEffect(e)
end
function c216444036.actcon(e)
	local tp=e:GetHandlerPlayer()
	return c216444036.actfilter(Duel.GetAttacker(),tp) or c216444036.actfilter(Duel.GetAttackTarget(),tp)
end

function c216444036.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x10ec)
end
function c216444036.dmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return rp~=tp and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN) and Duel.IsExistingMatchingCard(c216444036.filter,tp,LOCATION_EXTRA,0,1,nil)
end
function c216444036.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mc=Duel.GetMatchingGroupCount(c216444036.filter,tp,LOCATION_ONFIELD,0,nil)
	if chk==0 then return mc>0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,400*mc)
end
function c216444036.dmop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local mc=Duel.GetMatchingGroupCount(c216444036.filter,tp,LOCATION_ONFIELD,0,nil)
	Duel.Damage(p,mc*400,REASON_EFFECT)
end
