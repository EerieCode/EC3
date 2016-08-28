--オッドアイズ・ウェルプ
--Odd-Eyes Whelp
--Created and scripted by Eerie Code
function c213456001.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--Recover
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1,213456001)
	e1:SetTarget(c213456001.thtg)
	e1:SetOperation(c213456001.thop)
	c:RegisterEffect(e1)
	--Pseudo-Pendulum
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,213456001+1)
	e2:SetCondition(c213456001.spcon)
	e2:SetOperation(c213456001.spop)
	e2:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e2)
end

function c213456001.thfil(c)
	return (c:IsSetCard(0x99) or c:IsSetCard(0x98)) and c:IsFaceup() and c:IsAbleToHand()
end
function c213456001.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c213456001.thfil,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function c213456001.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c213456001.thfil,tp,LOCATION_EXTRA,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c213456001.sppfil(c)
	return c:IsSetCard(0x98) or c:IsSetCard(0x99)
end
function c213456001.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local tc1=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local tc2=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	if not tc1 or not tc2 or not c213456001.sppfil(tc1) or not c213456001.sppfil(tc2) then
		--Debug.Message("Wrong cards in Pendulum Zone.")
		return false 
	end
	local scl1=tc1:GetLeftScale()
	local scl2=tc2:GetRightScale()
	if scl1>scl2 then scl1,scl2=scl2,scl1 end
	local lv=c:GetLevel()
	if scl1>=lv or scl2<=lv then
		--Debug.Message("Wrong Scale.")
		return false
	end
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c213456001.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(4)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1,true)
end
