--捕食植物スロース・ペーパランツ
--Predator Plant Sloth Paepalanthus
--Created and scripted by Eerie Code
function c213333001.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FLIP)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetOperation(c213333001.flipop)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCountLimit(1)
	e2:SetValue(c213333001.valcon)
	c:RegisterEffect(e2)
	--counter
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetCondition(c213333001.condition)
	e1:SetTarget(c213333001.target)
	e1:SetOperation(c213333001.operation)
	c:RegisterEffect(e1)
end

function c213333001.flipop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(213333001,RESET_EVENT+0x1fe0000,0,1)
end
function c213333001.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 and e:GetHandler():GetFlagEffect(213333001)>0
end

function c213333001.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()==e:GetHandler() and Duel.GetAttacker():GetControler()~=e:GetHandler():GetControler()
end
function c213333001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,0x1041,1)
end
function c213333001.operation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if not a:IsRelateToBattle() then return end
	a:AddCounter(0x1041,1)
	if not c213333001.global_check then
		c213333001.global_check=true
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetTarget(c213333001.lvtg)
		e3:SetValue(1)
		Duel.RegisterEffect(e3,0)
	end
end
function c213333001.lvtg(e,c)
	return c:GetCounter(0x1041)>0 and c:IsLevelAbove(1)
end
