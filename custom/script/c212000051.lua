--光波循環
--Cipher Circulation
--Created by ScarletKing, scripted by Eerie Code
function c212000051.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_LVCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,212000051)
	e1:SetCost(c212000051.spcost)
	e1:SetTarget(c212000051.sptg)
	e1:SetOperation(c212000051.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,212000051)
	e2:SetCondition(c212000051.setcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c212000051.settg)
	e2:SetOperation(c212000051.setop)
	c:RegisterEffect(e2)
	Duel.AddCustomActivityCounter(212000051,ACTIVITY_SUMMON,c212000051.counterfilter)
	Duel.AddCustomActivityCounter(212000051,ACTIVITY_SPSUMMON,c212000051.counterfilter)
end
function c212000051.counterfilter(c)
	return c:IsSetCard(0xe5)
end

function c212000051.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(212000051,tp,ACTIVITY_SUMMON)==0 and Duel.GetCustomActivityCount(212000051,tp,ACTIVITY_SPSUMMON)==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c212000051.sumlimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	Duel.RegisterEffect(e2,tp)
end
function c212000051.sumlimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsSetCard(0xe5)
end
function c212000051.spfil1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xe5) and Duel.IsExistingTarget(c212000051.spfil2,tp,LOCATION_GRAVE,0,1,nil,e,tp,c:GetLevel())
end
function c212000051.spfil2(c,e,tp,lv)
	return c:IsSetCard(0xe5) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c212000051.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c212000051.spfil1,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c212000051.spfil1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c212000051.spfil2,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,g1:GetFirst():GetLevel())
	local t={}
	local i=1
	local p=1
	for i=4,8 do
		t[p]=i
		p=p+1
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,567)
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g2,1,0,0)
end
function c212000051.lvfil(c)
	return c:IsFaceup() and c:IsSetCard(0xe5) and c:IsLevelAbove(1)
end
function c212000051.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=2 then return end
	local fc=g:GetFirst()
	local tc=g:GetNext()
	if tc==e:GetLabelObject() then fc,tc=tc,fc end
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	Duel.BreakEffect()
	local mg=Duel.GetMatchingGroup(c212000051.lvfil,tp,LOCATION_MZONE,0,nil)
	local mc=mg:GetFirst()
	local lv=e:GetLabel()
	while mc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		mc:RegisterEffect(e1)
		mc=mg:GetNext()
	end
end

function c212000051.setcfil(c)
	return c:IsSetCard(0xe5) and c:IsSummonType(SUMMON_TYPE_XYZ) and c:IsControler(tp)
end
function c212000051.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c212000051.setcfil,1,nil,tp)
end
function c212000051.setfil(c)
	return c:IsSetCard(0xe5) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsCode(212000051) and c:IsSSetable()
end
function c212000051.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c212000051.setfil(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c212000051.setfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	Duel.SelectTarget(tp,c212000051.setfil,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c212000051.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<1 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
end
