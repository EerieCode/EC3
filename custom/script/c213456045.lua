--覇王炎竜オッドアイズ・ハート・ドラゴン
--Odd-Eyes Heart Dragon
--Created and scripted by Eerie Code
function c213456045.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	c:EnableReviveLimit()
	--Summon limit
	local e1=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	e3:SetValue(c213456045.splimit)	
	c:RegisterEffect(e1)
	--Ritual Summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1445,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c213456045.rittg)
	e2:SetOperation(c213456045.ritop)
	c:RegisterEffect(e2)
	--Recover (Pendulum)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1445,1))
	e3:SetCategory(CATEGORY_RECOVER)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCountLimit(1)
	e3:SetCondition(c213456045.rccon1)
	e3:SetTarget(c213456045.rctg1)
	e3:SetOperation(c213456045.rcop1)
	c:RegisterEffect(e3)
	--Recover & Damage
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_RECOVER+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c213456045.rccon2)
	e4:SetTarget(c213456045.rctg2)
	e4:SetOperation(c213456045.rcop2)
	c:RegisterEffect(e4)
	--Double ATK
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c213456045.atkcon)
	e5:SetCost(c213456045.atkcost)
	e5:SetOperation(c213456045.atkop)
	c:RegisterEffect(e5)
	--Place in Pendulum Zone
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(80896940,5))
	e7:SetCategory(CATEGORY_DESTROY)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e7:SetCode(EVENT_DESTROYED)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	e7:SetCondition(c213456045.pencon)
	e7:SetTarget(c213456045.pentg)
	e7:SetOperation(c213456045.penop)
	c:RegisterEffect(e7)
	--Check for proper summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c213456045.checkcon)
	e0:SetOperation(c213456045.checkop)
	c:RegisterEffect(e0)
	if not c213456045.global_flag then
		c213456045.global_flag=true
		c213456045.summon_map={}
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetCondition(c213456045.resetcon)
		ge1:SetOperation(c213456045.resetop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_TO_DECK)
		Duel.RegisterEffect(ge2,0)
	end
end

function c213456045.resetcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(Card.IsCode,1,nil,213456045)
end
function c213456045.resetop(e,tp,eg,ep,ev,re,r,rp)
	if not eg then return end
	local g=eg:Filter(Card.IsCode,1,nil,213456045)
	local tc=g:GetFirst()
	while tc do
		local rid=tc:GetRealFieldID()
		c213456045.summon_map[rid]=false
		tc=g:GetNext()
	end
end

function c213456045.splimit(e,se,sp,st)
	local c=e:GetHandler()
	return bit.band(st,SUMMON_TYPE_RITUAL)==SUMMON_TYPE_RITUAL or (c:IsLocation(LOCATION_EXTRA) and c213456045[c:GetRealFieldID()])
end

function c213456045.ritfil(c)
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and (c:IsType(TYPE_RITUAL) or (c:IsType(TYPE_PENDULUM) and bit.band(c:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM))
end
function c213456045.rittg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local mg=Duel.GetRitualMaterial(tp):Filter(c213456045.ritfil,nil)
		return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL+1,tp,false,false) and mg:CheckWithSumGreater(Card.GetRitualLevel,c:GetOriginalLevel(),c)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c213456045.ritop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local mg=Duel.GetRitualMaterial(tp):Filter(c213456045.ritfil,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local mat=mg:SelectWithSumGreater(tp,Card.GetRitualLevel,c:GetOriginalLevel(),c)
	c:SetMaterial(mat)
	Duel.ReleaseRitualMaterial(mat)
	Duel.BreakEffect()
	Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL+1,tp,tp,false,true,POS_FACEUP)
	c:CompleteProcedure()
end

function c213456045.checkcon(e)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_RITUAL+1)==SUMMON_TYPE_RITUAL+1
end
function c213456045.checkop(e,tp,eg,ep,ev,re,r,rp)
	local rid=e:GetHandler():GetRealFieldID()
	c213456045[rid]=true
end

function c213456045.rccon1(e,tp,eg,ep,ev,re,r,rp)
	local loc=e:GetHandler():GetPreviousLocation()
	return loc==LOCATION_MZONE or loc==LOCATION_EXTRA
end
function c213456045.rctg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local mc=Duel.GetMatchingGroupCount(c213456045.ritfil,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return mc:GetCount()>0 end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500*mc)
end
function c213456045.rcop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local mc=Duel.GetMatchingGroupCount(c213456045.ritfil,tp,LOCATION_MZONE,0,nil)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Recover(p,mc*500,REASON_EFFECT)
end

function c213456045.rccon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()bit.band(:GetSummonType(),SUMMON_TYPE_RITUAL+1)==SUMMON_TYPE_RITUAL+1
end
function c213456045.rctg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local mg=e:GetHandler():GetMaterial()
	local lv=0
	local tc=mg:GetFirst()
	while tc do
		lv=lv+tc:GetOriginalLevel()
	end
	e:SetLabel(lv)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,200*lv)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,100*lv)
end
function c213456045.rcop2(e,tp,eg,ep,ev,re,r,rp)
	local lv=e:GetLabel()
	local rc=Duel.Recover(tp,200*lv,REASON_EFFECT)
	if rc>0 then
		Duel.Damage(1-tp,math.floor(rc/2),REASON_EFFECT)
	end
end

function c213456045.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattleTarget() and e:GetHandler():GetFlagEffect(213456045)
end
function c213456045.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
	e:GetHandler():RegisterFlagEffect(213456045,RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function c213456045.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(c:GetBaseAttack()*2)
	c:RegisterEffect(e1)
end

function c213456045.pencon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c213456045.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,6) or Duel.CheckLocation(tp,LOCATION_SZONE,7) end
end
function c213456045.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_SZONE,6) and not Duel.CheckLocation(tp,LOCATION_SZONE,7) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
