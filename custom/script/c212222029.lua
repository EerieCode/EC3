--Ｎｘ・ＨＥＲＯ ザ・スコール
--NEXT HERO - The Squall
--Created and scripted by Eerie Code
function c212222029.initial_effect(c)
	c:EnableReviveLimit()
	--Fusion Procedure
	local fe=Effect.CreateEffect(c)
	fe:SetType(EFFECT_TYPE_SINGLE)
	fe:SetCode(EFFECT_FUSION_MATERIAL)
	fe:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	fe:SetCondition(c212222029.fuscon)
	fe:SetOperation(c212222029.fusop)
	c:RegisterEffect(fe)
	--add code
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_ADD_CODE)
	e0:SetValue(83121692)
	c:RegisterEffect(e0)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(c212222029.splimit)
	c:RegisterEffect(e1)
	--Attribute
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_ATTRIBUTE)
	e2:SetRange(LOCATION_MZONE+LOCATION_GRAVE)
	e2:SetValue(ATTRIBUTE_LIGHT+ATTRIBUTE_WATER)
	c:RegisterEffect(e2)
	--mat check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c212222029.valcheck)
	c:RegisterEffect(e3)
	--set target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCost(c212222029.cost)
	e4:SetTarget(c212222029.target)
	e4:SetOperation(c212222029.operation)
	c:RegisterEffect(e4)
end

function c212222029.matfil1(c)
	return c:IsFusionSetCard(0x3008) and c:IsAttribute(ATTRIBUTE_WIND)
end
function c212222029.matfil2(c)
	return c:IsFusionSetCard(0x3008) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c212222029.matfil3(c)
	return c:IsFusionSetCard(0x3008) and c:IsAttribute(ATTRIBUTE_WATER)
end
function c212222029.matexfil(c,mg,gc,i)
	local g=mg:Clone()
	g:RemoveCard(gc)
	if bit.band(i,1)~=0 then
		if bit.band(i,2)~=0 then
			return c212222029.matfil3(c)
		else
			return c212222029.matfil2(c) and g:IsExists(c212222029.matfil3,1,c)
		end
	elseif bit.band(i,2)~=0 then
		if bit.band(i,4)~=0 then
			return c212222029.matfil1(c)
		else
			return c212222029.matfil3(c) and g:IsExists(c212222029.matfil1,1,c)
		end
	elseif bit.band(i,4)~=0 then
		if bit.band(i,1)~=0 then
			return c212222029.matfil2(c)
		else
			return c212222029.matfil1(c) and g:IsExists(c212222029.matfil2,1,c)
		end
	end
end
function c212222029.fuscf2(c,g2,g3)
	local mg2=g2:Clone()
	local mg3=g3:Clone()
	if mg2:IsContains(c) then mg2:RemoveCard(c) end
	if mg3:IsContains(c) then mg3:RemoveCard(c) end
	return mg2:IsExists(c212222029.fuscf3,1,nil,g3)
end
function c212222029.fuscf3(c,g3)
	return g3:IsExists(aux.TRUE,1,c)
end
function c212222029.fuscon(e,g,gc,chkfnf)
	if g==nil then return true end
	local chkf=bit.band(chkfnf,0xff)
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler()) then return false end
		return 
			(c212222029.matfil1(gc) and mg:IsExists(c212222029.matexfil,1,nil,mg,gc,1))
			or (c212222029.matfil2(gc) and mg:IsExists(c212222029.matexfil,1,nil,mg,gc,2))
			or (c212222029.matfil3(gc) and mg:IsExists(c212222029.matexfil,1,nil,mg,gc,4))
	end
	local g1=Group.CreateGroup()
	local g2=Group.CreateGroup()
	local g3=Group.CreateGroup()
	local fs=false
	local tc=mg:GetFirst()
	while tc do
		if c212222029.matfil1(tc) then g1:AddCard(tc) end
		if c212222029.matfil2(tc) then g2:AddCard(tc) end
		if c212222029.matfil2(tc) then g3:AddCard(tc) end
		if aux.FConditionCheckF(tc,chkf) then fs=true end
		tc=mg:GetNext()
	end
	if chkf~=PLAYER_NONE then 
		return fs and g1:IsExists(c212222029.fuscf2,1,nil,g2,g3)
	else
		return g1:IsExists(c212222029.fuscf2,1,nil,g2,g3)
	end
end
function c212222029.fcf(c,f1,f2,f3)
	local b=false
	if f3 then b=(b or f3(c)) end
	if f2 then b=(b or f2(c)) end
	return b or f1(c)
end
function c212222029.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	local chkf=bit.band(chkfnf,0xff)
	local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	if gc then
		local sg=Group.CreateGroup()
		if c212222029.matfil1(gc) then
			sg:Merge(g:Filter(c212222029.matfil2,gc))
			sg:Merge(g:Filter(c212222029.matfil3,gc))
		end
		if c212222029.matfil2(gc) then
			sg:Merge(g:Filter(c212222029.matfil1,gc))
			sg:Merge(g:Filter(c212222029.matfil3,gc))
		end
		if c212222029.matfil3(gc) then
			sg:Merge(g:Filter(c212222029.matfil1,gc))
			sg:Merge(g:Filter(c212222029.matfil2,gc))
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=sg:Select(tp,1,1,nil)
		Duel.SetFusionMaterial(g1)
		return
	end
	local sg=g:Filter(c212222029.fcf,nil,c212222029.matfil1,c212222029.matfil2,c212222029.matfil3)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then
		g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else g1=sg:Select(tp,1,1,nil) end
	sg:RemoveCard(g1:GetFirst())
	for i=2,3 do
		local b1=(g1:FilterCount(c212222029.matfil1,nil))
		local b2=(g1:FilterCount(c212222029.matfil2,nil))
		local b3=(g1:FilterCount(c212222029.matfil3,nil))
		local g2=nil
		if b1 and b2 and b3 then
			g2=sg:Select(tp,1,1,nil)
		elseif b1 and b2 then
			g2=sg:FilterSelect(tp,c212222029.fcf,nil,c212222029.matfil3)
		elseif b1 and b3 then
			g2=sg:FilterSelect(tp,c212222029.fcf,nil,c212222029.matfil2)
		elseif b2 and b3 then
			g2=sg:FilterSelect(tp,c212222029.fcf,nil,c212222029.matfil1)
		elseif b1 then
			g2=sg:FilterSelect(tp,c212222029.fcf,nil,c212222029.matfil2,c212222029.matfil3)
		elseif b2 then
			g2=sg:FilterSelect(tp,c212222029.fcf,nil,c212222029.matfil1,c212222029.matfil3)
		elseif b3 then
			g2=sg:FilterSelect(tp,c212222029.fcf,nil,c212222029.matfil2,c212222029.matfil1)
		end
		sg:RemoveCard(g2:GetFirst())
		g1:Merge(g2)
	end
	Duel.SetFusionMaterial(g1)
end

function c212222029.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end

function c212222029.valfil(c)
	return not (c:IsType(TYPE_MONSTER) and c:IsSetCard(0xedf))
end
function c212222029.valcheck(e,c)
	local g=c:GetMaterial()
	if g:FilterCount(c212222029.valfil,nil)==0 then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end

function c212222029.cfil(c,sq,tp)
	return c:IsAbleToGrave() and Duel.IsExistingTarget(c212222029.fil,tp,LOCATION_MZONE,0,1,c,sq)
end
function c212222029.fil(c,sq)
	return c~=sq and c:IsFaceup() and c:IsSetCard(0x8) and not sq:IsHasCardTarget(c)
end
function c212222029.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c212222029.cfil,tp,LOCATION_ONFIELD,0,1,c,c,tp) and c:GetFlagEffect(212222029)<=e:GetLabel() end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c212222029.cfil,tp,LOCATION_ONFIELD,0,1,1,c,c,tp)
	Duel.SendtoGrave(g,REASON_COST)
	c:RegisterFlagEffect(212222029,RESET_EVENT+0x1fe0000,0,0)
end
function c212222029.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c212222029.fil(chkc,c) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c212222029.fil,tp,LOCATION_MZONE,0,1,1,nil,c)
end
function c212222029.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	if not tc:IsRelateToEffect(e) then return end
	c:SetCardTarget(tc)
	if c:GetFlagEffect(212222029+1)==0 then
		c:RegisterFlagEffect(212222029+1,RESET_EVENT+0x1fe0000,0,0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e1:SetTarget(c212222029.indtg)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
		c:RegisterEffect(e2)
	end
end
function c212222029.indtg(e,c)
	return e:GetHandler():IsHasCardTarget(c)
end
