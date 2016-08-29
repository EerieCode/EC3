--ＣＣＣ 剣融化身アンノウン・ダガー
--C/C/C Attributed Daggers of Conflict
--Created by F0futurehope, scripted by Eerie Code
function c216134040.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,216134000,c216134040.matfil,1,false,false)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c216134040.discon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetTarget(c216134040.atktg)
	e3:SetOperation(c216134040.atkop)
	c:RegisterEffect(e3)
	--destroy replace
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EFFECT_DESTROY_REPLACE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetTarget(c216134040.reptg)
	c:RegisterEffect(e9)
end

function c216134040.matfil(c)
	local lv=math.max(c:GetLevel(),c:GetRank())
	return lv<=4
end

function c216134040.discon(e)
	return not e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION+0x20)
end

function c216134040.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=Duel.GetAttackTarget()
	if chk==0 then return d end
end
function c216134040.atkfil(c,attr)
	return c:IsFaceup() and c:IsAttribute(attr)
end
function c216134040.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local atk=Duel.GetMatchingGroup(c216134040.atkfil,tp,0,LOCATION_MZONE,nil,c:GetAttribute()):GetSum(Card.GetAttack)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(math.floor(atk/2))
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	c:RegisterEffect(e1)
end

function c216134040.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_EFFECT) and not c:IsDisabled() end
	if Duel.SelectYesNo(tp,aux.Stringid(1020,0)) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		c:RegisterEffect(e2)
		return true
	else return false end
end
