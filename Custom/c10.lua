--イーリコード・トーカー
--...yup, I'm totally doing that
--Created and scripted by... oh, come on, like it's not obvious!
function c10.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,nil,2,2)
	--no cards for you, nekrozar!
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c10.invtg)
	c:RegisterEffect(e1)
	--because it's the archetype's hat
	--because GIVE US MORE SUPPORT, DANG IT!
end
function c10.invtg(e,c)
	return e:GetHandler():GetLinkedGroup():IsContains(c)
end
