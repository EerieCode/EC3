--ＥＭオールカバー・ヒッポ
--Performapal Allcover Hippo
--Scripted by Eerie Code
function c100910003.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(100910003,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c100910003.sptg)
	e1:SetOperation(c100910003.spop)
	c:RegisterEffect(e1)
	--Change position
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(100910003,1))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c100910003.postg)
	e2:SetOperation(c100910003.posop)
	c:RegisterEffect(e2)
end
