--Ｎ・ＨＥＲＯ ワイルドキッド
--NEXT HERO - Wild Kid
--Created and scripted by Eerie Code
function c212222006.initial_effect(c)
	--add code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetValue(86188410)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c212222006.actcon)
	e1:SetCost(c212222006.actcost)
	e1:SetOperation(c212222006.actop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c212222006.fuscon)
	e2:SetOperation(c212222006.fusop)
	c:RegisterEffect(e2)
end

function c212222006.actcon(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.IsAbleToEnterBP() or (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE))
end
function c212222006.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,212222006)==0 end
	Duel.RegisterFlagEffect(tp,212222006,RESET_PHASE+PHASE_END,0,1)
end
function c212222006.actop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c212222006.aclimit)
	e3:SetCondition(c212222006.accon)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c212222006.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c212222006.accon(e)
	local atk=Duel.GetAttacker()
	return atk and atk:IsSetCard(0x3008) and atk:IsControler(e:GetHandlerPlayer())
end

function c212222006.fuscfil(c)
	return not c:IsSetCard(0xedf)
end
function c212222006.fuscon(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	return r==REASON_FUSION and rc:IsSetCard(0x8) and not rc:GetMaterial():IsExists(c212222006.fuscfil,1,nil)
end
function c212222006.fusop(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.GetFlagEffect(tp,212222000)~=0 and not Duel.IsPlayerAffectedByEffect(tp,212222000)) or Duel.GetFlagEffect(tp,212222006)~=0 or not Duel.SelectYesNo(tp,aux.Stringid(1016,5)) then return end
	Duel.RegisterFlagEffect(tp,212222000,RESET_CHAIN,0,1)
	Duel.RegisterFlagEffect(tp,212222006,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_CARD,0,212222006)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e4:SetDescription(aux.Stringid(1015,5))
	e4:SetValue(c212222006.efilter)
	e4:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e4)	
end
function c212222006.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:GetOwner()~=e:GetOwner()
		and te:IsActiveType(TYPE_SPELL+TYPE_TRAP)
end
