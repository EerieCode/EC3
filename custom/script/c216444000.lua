--デビルアイズ・ペンデュラム・ドラゴン
--Evil-Eyes Pendulum Dragon
--Created and scripted by Eerie Code
function c216444000.initial_effect(c)
	--
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c216444000.ffilter,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),false)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c216444000.condition)
	e1:SetOperation(c216444000.operation)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c216444000.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
end

function c216444000.ffilter(c)
	return c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_DARK)
end

function c216444000.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c216444000.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=e:GetLabel()
	local immtg=e:GetLabelObject()
	--ATK Down
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(-atk)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	if immtg then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(aux.tgoval)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
	end
end

function c216444000.valcheck(e,c)
	local g=c:GetMaterial():Filter(Card.IsRace,nil,RACE_FIEND)
	local tc=g:GetFirst()
	local atk=0
	if tc then
		atk=tc:GetTextAttack()
		if tc:IsLevelAbove(5) and tc:IsLocation(LOCATION_MZONE) and bit.band(tc:GetSummonType(),SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM then
			e:GetLabelObject():SetLabelObject(tc)
		end
	end
	e:GetLabelObject():SetLabel(atk)
end
