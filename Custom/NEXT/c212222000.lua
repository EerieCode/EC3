--Ｎ－オーバーテーキング
--NEXT Overtaking
--Created and scripted by Eerie Code
function c212222000.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,212222000+EFFECT_COUNT_CODE_OATH)
	e1:SetCost(c212222000.cost)
	e1:SetOperation(c212222000.activate)
	c:RegisterEffect(e1)
	Duel.AddCustomActivityCounter(212222000,ACTIVITY_SPSUMMON,c212222000.counterfilter)
end

function c212222000.fuscfil(c)
	return not c:IsSetCard(0xedf)
end
function c212222000.counterfilter(c)
	return c:IsSetCard(0xedf) or (c:IsSetCard(0x8) and bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and not c:GetMaterial():IsExists(c212222000.fuscfil,1,nil))
end
function c212222000.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(212222000,tp,ACTIVITY_SPSUMMON)==0 end
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c212222000.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e2:SetTarget(c212222000.fuscfil)
	c:RegisterEffect(e2)
end
function c212222000.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xedf) and not (c:IsSetCard(0x8) and bit.band(sumtype,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION)
end
function c212222000.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(212222000)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
