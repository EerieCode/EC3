--アンダークロックテイカー
--Underclock Taker
--Scripted by Eerie Code
function c101003039.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101003039,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c101003039.target)
	e1:SetOperation(c101003039.operation)
	c:RegisterEffect(e1)
end
function c101003039.filter(c,lg)
	return c:IsFaceup() and c:GetAttack()>0 and lg:IsContains(c)
end
function c101003039.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local lg=e:GetHandler():GetLinkedGroup()
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingTarget(c101003039.filter,tp,LOCATION_MZONE,1,nil,lg) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101003039.filter,tp,LOCATION_MZONE,0,1,1,nil,lg)
end
function c101003039.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=2 then return end
	local oc=g:GetFirst()
	local tc=g:GetNext()
	if oc:IsControler(tp) then oc,tc=tc,oc end
	if oc:IsFaceup() and tc:IsFaceup() then
		local atk=tc:GetAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-atk)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		oc:RegisterEffect(e1)
	end
end
