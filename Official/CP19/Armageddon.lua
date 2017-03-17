--DDD超死偉王ダークネス・ヘル・アーマゲドン
--D/D/D Superdoom King Darkness Armageddon
--Scripted by Eerie Code
function c100217008.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x10af),8,2)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100217008,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c100217008.spcon)
	e1:SetTarget(c100217008.sptg)
	e1:SetOperation(c100217008.spop)
	c:RegisterEffect(e1)
end
function c100217008.spcon(e,tp,eg,ep,ev,re,r,rp)
	local pc=Duel.GetFieldCard(tp,LOCATION_SZONE,13-e:GetHandler():GetSequence())
	return pc and pc:IsSetCard(0xaf)
end
function c100217008.spfilter(c,e,tp)
	return c:IsSetCard(0x10af) and c:IsType(TYPE_XYZ) and not c:IsCode(100217008)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
