--幻影騎士団ドライダインスレイブ
--The Phantom Knights of Parched Dainsleif
--Created and scripted by Eerie Code
function c216666042.initial_effect(c)
	--Xyz Summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x10db),5,3)
	c:EnableReviveLimit()
	--attack all
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c216666042.discon)
	c:RegisterEffect(e2)
	--activate limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(c216666042.accon)
	e3:SetValue(c216666042.aclimit)
	c:RegisterEffect(e3)
	--Redirect
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(c216666042.rdcon)
	e4:SetTarget(c216666042.rdtg)
	e4:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_ONFIELD)
	e5:SetValue(LOCATION_REMOVED)
	e5:SetCondition(c216666042.rdcon)
	e5:SetTarget(c216666042.rdtg2)
	c:RegisterEffect(e5)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE)
	e6:SetCost(c216666042.dacost)
	e6:SetTarget(c216666042.datg)
	e6:SetOperation(c216666042.daop)
	c:RegisterEffect(e6)
end

function c216666042.discon(e)
	local ec=e:GetHandler()
	return Duel.GetAttacker()==ec or Duel.GetAttackTarget()==ec
end

function c216666042.accon(e)
	local ph=Duel.GetCurrentPhase()
	return ph==PHASE_BATTLE or ph==PHASE_DAMAGE or ph==PHASE_DAMAGE_CAL
end
function c216666042.aclimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) and not re:GetHandler():IsImmuneToEffect(e)
end

function c216666042.rdfil(c)
	return c:IsSetCard(0x10db) and c:IsType(TYPE_XYZ)
end
function c216666042.rdcon(e)
	return e:GetHandler():GetOverlayGroup():IsExists(c216666042.rdfil,1,nil)
end
function c216666042.rdtg(e,c)
	return c:IsSetCard(0x10db)
end
function c216666042.rdtg2(e,c)
	return e:GetHandler():GetOwner()~=c:GetControler() and c:IsReason(REASON_DESTROY) and c:GetReasonCard():IsSetCard(0xdb) and c:GetReasonPlayer()==e:GetHandler():GetOwner()
end

function c216666042.dafil(c)
	return c:IsFaceup() and c:IsSetCard(0x10db)
end
function c216666042.dacost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c216666042.datg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c216666042.dafil,tp,LOCATION_MZONE,0,1,e:GetHandler()) and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c216666042.dafil,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g2=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,1,0,0)
end
function c216666042.daop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local lo=e:GetLabelObject()
	if not lo or not tg or tg:GetCount()~=2 then return end
	local ac=tg:GetFirst()
	local dc=tg:GetNext()
	if ac~=lo then ac,dc=dc,ac end
	if Duel.Destroy(dc,REASON_EFFECT)>0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(1000)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		ac:RegisterEffect(e1)
	end
end