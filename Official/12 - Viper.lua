--十二獣ヴァイパー
--Viper of the Twelve Beasts
--Scripted by Eerie Code
function c7516.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7516,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c7516.mtg)
	e1:SetOperation(c7516.mop)
	c:RegisterEffect(e1)
	if not c7514.global_flag then
		c7514.global_flag=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c7514.xspop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(0x40000)
		ge2:SetOperation(c7514.xmatop)
		Duel.RegisterEffect(ge2,0)
	end
end

function c7516.mfil(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:IsRace(RACE_BEASTWARRIOR)
end
function c7516.mtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c7516.mfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c7516.mfil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c7516.mfil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c7516.mop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) and c:IsRelateToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
		Duel.RaiseEvent(c,0x40000,e,0,0,0,0)
	end
end


function c7516.xfil(c,mc)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) 
		and bit.band(c:GetOriginalRace(),RACE_BEASTWARRIOR)==RACE_BEASTWARRIOR
		and ((c:GetMaterial() and c:GetMaterial():IsContains(mc)) or c:GetOverlayGroup():IsContains(mc))
		and c:GetFlagEffect(7516)==0
end
function c7516.xspop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=eg:Filter(c7516.xfil,nil,c)
	local tc=mg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(7516,RESET_EVENT+0x1fc0000,0,1)
		local e1=c7516.zodiac_effect(c)
		tc:RegisterEffect(e1)
	end
end
function c7516.xmatop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(c7516.xfil,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local tc=mg:GetFirst()
	while tc do
		tc:RegisterFlagEffect(7516,RESET_EVENT+0x1fc0000,0,1)
		local e1=c7516.zodiac_effect(c)
		tc:RegisterEffect(e1)
	end
end

function c7516.zodiac_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(7516,1))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLED)
	e1:SetTarget(c7516.rmtg)
	e1:SetOperation(c7516.rmop)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	return e1
end
function c7516.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local t=Duel.GetAttackTarget()
	local tbr=a
	if tbr==c then tbr==t end
	if chk==0 then return true end
	e:SetLabelObject(tbr)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,tbr,1,0,0)
end
function c7516.rmop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetLabelObject()
	if bc:IsRelateToBattle() then
		Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	end
end
