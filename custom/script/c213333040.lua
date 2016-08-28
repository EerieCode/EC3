--捕食植物ハイドラ・クスクータ
--Predator Plant Hydra Cuscuta
--Created and scripted by Eerie Code
function c213333040.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,c213333040.matfil1,c213333040.matfil2,1,63,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c213333040.matcheck)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(aux.tgval)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(2,213333040)
	e3:SetCondition(c213333040.negcon)
	e3:SetCost(c213333040.negcost)
	e3:SetTarget(c213333040.negtg)
	e3:SetOperation(c213333040.negop)
	c:RegisterEffect(e3)
end

function c213333040.matfil1(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_PLANT) and c:IsType(TYPE_FUSION)
end
function c213333040.matfil2(c)
	return c:IsAttribute(ATTRIBUTE_DARK) and not c:IsType(TYPE_TOKEN) and c:IsLocation(LOCATION_MZONE)
end

function c213333040.mfil(c)
	return c:GetPreviousLocation()==LOCATION_MZONE 
end
function c213333040.matcheck(e,c)
	--local mg=c:GetMaterial():Filter(c213333040.mfil,nil)
	local mg=c:GetMaterial():Filter(Card.IsLocation,nil,LOCATION_MZONE)
	--Debug.Message("Materials: "..mg:GetCount())
	local lv=0
	local mc=mg:GetFirst()
	while mc do
		--lv=lv+mc:GetPreviousLevelOnField()
		lv=lv+mc:GetLevel()
		mc=mg:GetNext()
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(200*lv)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	if EFFECT_SET_BASE_DEFENSE then
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	else
		e2:SetCode(EFFECT_SET_BASE_DEFENCE)
	end
	c:RegisterEffect(e2)
end

function c213333040.negcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.IsChainNegatable(ev)
end
function c213333040.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local atk=c:GetBaseAttack()
	local def=0
	local defcode=0
	if EFFECT_SET_BASE_DEFENSE then
		def=c:GetBaseDefense()
		defcode=(EFFECT_SET_BASE_DEFENSE)
	else
		def=c:GetBaseDefence()
		defcode=(EFFECT_SET_BASE_DEFENCE)
	end
	if chk==0 then return atk>=500 and def>=500 end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(atk-500)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(defcode)
	e2:SetValue(def-500)
	c:RegisterEffect(e2)
end
function c213333040.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c213333040.negop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.NegateActivation(ev)
end
