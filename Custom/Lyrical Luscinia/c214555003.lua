--ＬＬ－トパーズ・スターリング
--Lyrical Luscinia - Topaz Starling
--Created by Isaiahj95, scripted by Eerie Code
function c214555003.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,214555003)
	e1:SetCondition(c214555003.thcon)
	e1:SetTarget(c214555003.thtg)
	e1:SetOperation(c214555003.thop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,214555003)
	e2:SetTarget(c214555003.tg)
	e2:SetOperation(c214555003.op)
	c:RegisterEffect(e2)
end

function c214555003.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and bit.band(c:GetPreviousLocation(),LOCATION_OVERLAY)~=0
end
function c214555003.thfil(c)
	return c:GetLevel()==1 and not c:IsCode(214555003) and c:IsAbleToHand()
end
function c214555003.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c214555003.thfil,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c214555003.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c214555003.thfil,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c214555003.xfil(c,mc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c)
end
function c214555003.nxfil(c)
	return c:IsFaceup() and not c:IsType(TYPE_XYZ) and c:IsLevelAbove(1)
end
function c214555003.fil(c,mc)
	return c214555003.xfil(c,mc) or c214555003.nxfil(c)
end
function c214555003.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local b=c:IsAbleToRemove()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c214555003.xfil,tp,LOCATION_MZONE,0,1,nil,c) or (b and Duel.IsExistingTarget(c214555003.nxfil,tp,LOCATION_MZONE,0,1,nil,c))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	if b then
		Duel.SelectTarget(tp,c214555003.fil,tp,LOCATION_MZONE,0,1,nil,c)
	else
		Duel.SelectTarget(tp,c214555003.xfil,tp,LOCATION_MZONE,0,1,nil,c)
	end
end
function c214555003.cfil(c)
	return c:GetLevel()==1 and c:IsAbleToRemove()
end
function c214555003.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	if tc:IsType(TYPE_XYZ) then
		Duel.Overlay(tc,c)
	else
		if not c:IsAbleToRemove() then return end
		local g=Duel.GetMatchingGroup(c214555003.cfil,tp,LOCATION_GRAVE,0,c)
		local bg=Group.CreateGroup()
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(1017,3)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local bg=g:Select(tp,1,99,nil)
		end
		bg:AddCard(c)
		local oc=Duel.Remove(bg,POS_FACEUP,REASON_EFFECT)
		Duel.BreakEffect()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(oc)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		tc:RegisterEffect(e1)
	end
end
