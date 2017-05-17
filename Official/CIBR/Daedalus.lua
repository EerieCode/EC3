--メタファイズ・ダイダロス
--Metaphys Daedalus
--Scripted by Eerie Code
function c101002024.initial_effect(c)
	--banish
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101002024,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c101002024.rmcon)
	e1:SetTarget(c101002024.rmtg)
	e1:SetOperation(c101002024.rmop)
	c:RegisterEffect(e1)
	--banish from deck
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101002024,1))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCondition(c101002024.rmcon2)
	e2:SetCost(c101002024.rmcost2)
	e2:SetTarget(c101002024.rmtg2)
	e2:SetOperation(c101002024.rmop2)
	c:RegisterEffect(e2)
end
