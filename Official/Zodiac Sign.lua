--ゾディアックＳ
--Zodiac Sign
--Scripted by Eerie code
function c7558.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atk&def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(300)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0xf2))
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--at limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_FZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetValue(c7558.atlimit)
	c:RegisterEffect(e4)
	--destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTarget(c7558.reptg)
	e5:SetValue(c7558.repval)
	e5:SetOperation(c7558.repop)
	c:RegisterEffect(e5)
end

function c7558.atkfil(c,atk)
	return c:IsFaceup() and c:IsRace(RACE_BEASTWARRIOR) and c:GetAttack()>atk
end
function c7558.atlimit(e,c)
	return c:IsFaceup() and c:IsRace(RACE_BEASTWARRIOR) and not Duel.IsExistingMatchingCard(c7558.atkfil,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,c,c:GetAttack())
end

function c7558.repfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xf2)
		and (c:IsReason(REASON_EFFECT)) and not c:IsReason(REASON_REPLACE)
end
function c7558.desfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_HAND+LOCATION_MZONE) and c:IsSetCard(0xf2)
		and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED)
end
function c7558.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c7558.repfilter,1,nil,tp)
		and Duel.IsExistingMatchingCard(c7558.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil,tp)
		and e:GetHandler():GetFlagEffect(7558)==0 end
	if Duel.SelectYesNo(tp,aux.Stringid(7558,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,c7558.desfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil,tp)
		e:SetLabelObject(g:GetFirst())
		Duel.HintSelection(g)
		g:GetFirst():SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	end
	return false
end
function c7558.repval(e,c)
	return c7558.repfilter(c,e:GetHandlerPlayer())
end
function c7558.repop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	tc:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.Destroy(tc,REASON_EFFECT+REASON_REPLACE)
	e:GetHandler():RegisterFlagEffect(7558,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
