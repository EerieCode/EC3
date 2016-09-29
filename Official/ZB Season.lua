--十二獣の方合
--Seasonal Direction of the Zodiac Beasts
--Scripted by Eerie Code
function c7571.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c7571.xyztg)
	e1:SetOperation(c7571.xyzop)
	c:RegisterEffect(e1)
end

function c7571.xyzfil(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsSetCard(0xf2)
end
function c7571.xyzfil2(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xf2)
end
function c7571.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c7571.xyzfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c7571.xyzfil,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c7571.xyzfil2,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c7571.xyzfil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c7571.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c7571.xyzfil2,tp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.Overlay(tc,g)
		end
	end
end
