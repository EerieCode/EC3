--ＳＲパッシングライダー
--Speedroid Passing Rider
--Scripted by Eerie Code
function c6145.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6145,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c6145.sccost)
	e1:SetTarget(c6145.sctg)
	e1:SetOperation(c6145.scop)
	c:RegisterEffect(e1)
end

function Card.GetScale(c)
	local seq=c:GetSequence()
	if seq<6 then return 0 end
	if seq==6 then return c:GetLeftScale() else return c:GetRightScale() end
end

function c6145.scfil(c)
	return c:IsSetCard(SET_SR) and c:IsType(TYPE_TUNER) and (c:IsFaceup() or c:IsLocation(LOCATION_HAND)) 
		and c:IsAbleToGraveAsCost()
end
function c6145.sccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c6145.sccost,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c6145.sccost,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	e:SetLabelObject(g:GetFirst())
	Duel.SendtoGrave(g,REASON_COST)
end
function c6145.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local op=0
	if c:GetScale()==1 then
		op=Duel.SelectOption(tp,aux.Stringid(6145,0))
	else
		op=Duel.SelectOption(tp,aux.Stringid(6145,0),aux.Stringid(6145,1))
	end
	e:SetLabel(op)
end
function c6145.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local lv=e:GetLabelObject():GetOriginalLevel()
	local op=e:GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LSCALE)
	if op==0 then
		e1:SetValue(lv)
	else
		if lv>=c:GetScale() then lv=c:GetScale()-1 end
		e1:SetValue(-lv)
	end
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_RSCALE)
	c:RegisterEffect(e2)
end
