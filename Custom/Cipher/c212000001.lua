--光波反射飛竜
--Cipher Reflect Wyvern
--Created by ScarletKing, scripted by Eerie Code
function c212000001.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCost(c212000001.spcost)
	e1:SetTarget(c212000001.sptg)
	e1:SetOperation(c212000001.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_LVCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c212000001.lvtg)
	e2:SetOperation(c212000001.lvop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(212000001,ACTIVITY_SUMMON,c212000001.counterfilter)
	Duel.AddCustomActivityCounter(212000001,ACTIVITY_SPSUMMON,c212000001.counterfilter)
end
function c212000001.counterfilter(c)
	return c:IsSetCard(0xe5)
end

function c212000001.spcfil(c)
	return c:IsSetCard(0xe5) and c:IsAbleToGraveAsCost()
end
function c212000001.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c212000001.spcfil,tp,LOCATION_HAND,0,1,nil) and Duel.GetCustomActivityCount(212000001,tp,ACTIVITY_SUMMON)==0 and Duel.GetCustomActivityCount(212000001,tp,ACTIVITY_SPSUMMON)==0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c212000001.spcfil,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c212000001.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c212000001.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xe5)
end
function c212000001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c212000001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP) then
		if c:GetPreviousLocation()==LOCATION_GRAVE then
			c:RegisterFlagEffect(212000001,RESET_EVENT+0x1fe0000,0,1)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x47e0000)
			e1:SetValue(LOCATION_REMOVED)
			c:RegisterEffect(e1,true)
			local e2=Effect.GlobalEffect()
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_TO_GRAVE_REDIRECT)
			e2:SetValue(LOCATION_REMOVED)
			e2:SetTarget(c212000001.rmtg)
			e2:SetTargetRange(LOCATION_OVERLAY,LOCATION_OVERLAY)
			e2:SetLabelObject(c)
			e2:SetReset(RESET_PHASE+PHASE_END,3)
			Duel.RegisterEffect(e2,0)
		end
		Duel.SpecialSummonComplete()
	elseif c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsLocation(LOCATION_HAND) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c212000001.rmtg(e,c)
	return c:GetFlagEffect(212000001)>0
end

function c212000001.lvfil(c,lv)
	return c:IsFaceup() and c:GetLevel()~=lv and c:IsSetCard(0xe5)
end
function c212000001.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc~=c and c212000001.lvfil(chkc,lv) end
	if chk==0 then return Duel.IsExistingTarget(c212000001.lvfil,tp,LOCATION_MZONE,0,1,c,lv) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c212000001.lvfil,tp,LOCATION_MZONE,0,1,1,c,lv)
	local op=Duel.SelectOption(tp,aux.Stringid(1012,1),aux.Stringid(1012,2))
	e:SetLabel(op)
end
function c212000001.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local op=e:GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	if op==0 then
		e1:SetValue(c:GetLevel())
		tc:RegisterEffect(e1)
	else
		e1:SetValue(tc:GetLevel())
		c:RegisterEffect(e1)
	end
end
