--捕食植物ゲイル・ジオナイア
--Predator Plant Gale Dionaea
--Created and scripted by Eerie Code
function c213333005.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,213333005)
	e1:SetCost(c213333005.tkcost)
	e1:SetTarget(c213333005.tktg)
	e1:SetOperation(c213333005.tkop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCost(c213333005.atkcost)
	e2:SetTarget(c213333005.atktg)
	e2:SetOperation(c213333005.atkop)
	c:RegisterEffect(e2)
end

function c213333005.tkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c213333005.tktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>1 and Duel.IsPlayerCanSpecialSummonMonster(tp,213333005+1,0xedb,0x4011,300,300,1,RACE_PLANT,ATTRIBUTE_DARK,POS_FACEUP_ATTACK,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c213333005.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<2 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,213333005+1,0xedb,0x4011,300,300,1,RACE_PLANT,ATTRIBUTE_DARK,POS_FACEUP_ATTACK,1-tp) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,213333005+1)
		Duel.SpecialSummonStep(token,0,tp,1-tp,false,false,POS_FACEUP_ATTACK)
		token:AddCounter(0x1041,1)
	end
	Duel.SpecialSummonComplete()
	if not c213333005.global_flag then
		c213333005.global_flag=true
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetCode(EFFECT_CHANGE_LEVEL)
		e3:SetTarget(c213333005.lvtg)
		e3:SetValue(1)
		Duel.RegisterEffect(e3,0)
	end
end
function c213333005.lvtg(e,c)
	return c:GetCounter(0x1041)>0 and c:IsLevelAbove(1)
end

function c213333005.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsDiscardable() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c213333005.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsControler(1-tp) then a,d=d,a end
	if chk==0 then 
		if Card.GetDefense then
			return a:GetAttack()~=a:GetBaseAttack() or a:GetDefense()~=a:GetBaseDefense() or d:GetAttack()~=d:GetBaseAttack() or d:GetDefense()~=d:GetBaseDefense()
		else
			return a:GetAttack()~=a:GetBaseAttack() or a:GetDefence()~=a:GetBaseDefence() or d:GetAttack()~=d:GetBaseAttack() or d:GetDefence()~=d:GetBaseDefence()
		end
	end
end
function c213333005.atkop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or a:IsFacedown() or not d or not d:IsRelateToBattle() or d:IsFacedown() then return end
	local adef=0
	local ddef=0
	local defcode=0
	if EFFECT_SET_DEFENSE_FINAL then
		defcode=EFFECT_SET_DEFENSE_FINAL
		adef=a:GetBaseDefense()
		ddef=d:GetBaseDefense()
	else
		defcode=EFFECT_SET_DEFENCE_FINAL
		adef=a:GetBaseDefence()
		ddef=d:GetBaseDefence()
	end
	local aatk=a:GetBaseAttack()
	local datk=d:GetBaseAttack()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(aatk)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	a:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetValue(datk)
	d:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(defcode)
	e3:SetValue(adef)
	a:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetValue(ddef)
	d:RegisterEffect(e4)
end
