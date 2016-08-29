--Ｎ・ＨＥＲＯ バブルラッド
--NEXT HERO - Bubblelad
--Created and scripted by Eerie Code
function c212222005.initial_effect(c)
	--add code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetValue(79979666)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCondition(c212222005.drcon)
	e1:SetCost(c212222005.drcost)
	e1:SetTarget(c212222005.drtg)
	e1:SetOperation(c212222005.drop)
	c:RegisterEffect(e1)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetCondition(c212222005.fuscon)
	e3:SetOperation(c212222005.fusop)
	c:RegisterEffect(e3)
end

function c212222005.drcon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return false end
	local rc=re:GetHandler()
	return rc:IsSetCard(0x8) and rc:IsSetCard(0xedf) and rc:IsType(TYPE_MONSTER) and Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)==0
end
function c212222005.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,212222005)==0 end
	Duel.RegisterFlagEffect(tp,212222005,RESET_PHASE+PHASE_END,0,1)
end
function c212222005.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c212222005.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end

function c212222005.fuscfil(c)
	return not c:IsSetCard(0xedf)
end
function c212222005.fuscon(e,tp,eg,ep,ev,re,r,rp)
	local rc=e:GetHandler():GetReasonCard()
	return r==REASON_FUSION and rc:IsSetCard(0x8) and not rc:GetMaterial():IsExists(c212222005.fuscfil,1,nil)
end
function c212222005.fusop(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.GetFlagEffect(tp,212222000)~=0 and not Duel.IsPlayerAffectedByEffect(tp,212222000)) or Duel.GetFlagEffect(tp,212222005)~=0 or not Duel.SelectYesNo(tp,aux.Stringid(1016,4)) then return end
	Duel.RegisterFlagEffect(tp,212222000,RESET_CHAIN,0,1)
	Duel.RegisterFlagEffect(tp,212222005,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_CARD,0,212222005)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	--disable
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetOperation(c212222005.disop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	rc:RegisterEffect(e2)
	rc:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(1015,4))
	if not rc:IsType(TYPE_EFFECT) then
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_ADD_TYPE)
		e0:SetValue(TYPE_EFFECT)
		e0:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e0,true)
	end
end
function c212222005.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		bc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		bc:RegisterEffect(e2)
	end
end
