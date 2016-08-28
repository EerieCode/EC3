--Ｎｏ．２４ 竜血鬼ドラギュラス
--Number 24: Dragon Nosferatu Dragulas
--Scripted by Eerie Code
function c7276.initial_effect(c)
  --xyz summon
	aux.AddXyzProcedure(c,nil,6,2)
	c:EnableReviveLimit()
	--Face-down
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7276,0))
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c7276.fdtg)
	e1:SetOperation(c7276.fdop)
	c:RegisterEffect(e1)
end

