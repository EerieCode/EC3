--覇王龍ズァーク
--Supreme King Dragon Zarc
--Scripted by Eerie Code
function c100912039.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c100912039.fuscon)
	e1:SetOperation(c100912039.fusop)
	c:RegisterEffect(e1)
end
function c100912039.fusfil(c,t)
	return c:IsRace(RACE_DRAGON) and c:IsType(t)
end
function c100912039.fuscon(e,g,gc,chkfnf)
	if g==nil then return false end
	local chkf=bit.band(chkfnf,0xff)
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
end
