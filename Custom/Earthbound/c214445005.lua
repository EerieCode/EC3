--地縛囚人グリフ・シアー
--Earthbound Prisoner Glyph Seer
--Created by ScarletKing, scripted by Eerie Code
function c214445005.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--scale change
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c214445005.sccon)
	e1:SetOperation(c214445005.scop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetOperation(c214445005.regop)
	c:RegisterEffect(e2)
	--double tribute
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DOUBLE_TRIBUTE)
	e3:SetValue(c214445005.condition)
	c:RegisterEffect(e3)
end

function c214445005.scfil(c)
	return c:IsFaceup() and c:IsType(TYPE_FIELD)
end
function c214445005.sccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c214445005.scfil,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
end
function c214445005.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LSCALE)
	e1:SetValue(11)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RSCALE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c214445005.splimit)
	e3:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c214445005.splimit(e,c)
	return not c:IsAttribute(ATTRIBUTE_DARK)
end

function c214445005.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetOperation(c214445005.cedop)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetLabelObject(e1)
	e2:SetOperation(c214445005.sucop)
	Duel.RegisterEffect(e2,tp)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	Duel.RegisterEffect(e3,tp)
end
function c214445005.chainlm(e,rp,tp)
	return tp==rp
end
function c214445005.sucfilter(c)
	return c:IsSetCard(0x21) or c:IsSetCard(0x2e21)
end
function c214445005.sucop(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(c214445005.sucfilter,1,nil) then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c214445005.cedop(e,tp,eg,ep,ev,re,r,rp)
	if (Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS) or Duel.CheckEvent(EVENT_SUMMON_SUCCESS)) and e:GetLabelObject():GetLabel()==1 then
		Duel.SetChainLimitTillChainEnd(c214445005.chainlm)
	end
end

function c214445005.condition(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
