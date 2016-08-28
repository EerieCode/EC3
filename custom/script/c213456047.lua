--覇王毒竜オッドアイズ・ヴェノム・ドラゴン
--Odd-Eyes Venom Dragon
--Created and scripted by Eerie Code
function c213456047.initial_effect(c)
	--Procedures
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	local fe=Effect.CreateEffect(c)
	fe:SetType(EFFECT_TYPE_SINGLE)
	fe:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	fe:SetCode(EFFECT_FUSION_MATERIAL)
	fe:SetCondition(c213456047.fscon)
	fe:SetOperation(c213456047.fsop)
	c:RegisterEffect(fe)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTargetRange(0,LOCATION_MZONE)
	e1:SetValue(c213456047.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--pendulum set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c213456047.pctg)
	e3:SetOperation(c213456047.pcop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DISABLE+CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(c213456047.vencon)
	e4:SetTarget(c213456047.ventg)
	e4:SetOperation(c213456047.venop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_MATERIAL_CHECK)
	e5:SetValue(c213456047.valcheck)
	e5:SetLabelObject(e4)
	c:RegisterEffect(e5)
	--pendulum
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCondition(c213456047.pencon)
	e6:SetTarget(c213456047.pentg)
	e6:SetOperation(c213456047.penop)
	c:RegisterEffect(e6)
end

function c213456047.filter(c,fc)
	return c:IsRace(RACE_DRAGON) and c:IsPreviousLocation(LOCATION_EXTRA) and c:IsLevelAbove(1) and c:IsCanBeFusionMaterial(fc)
end
function c213456047.fusfil(c,mg)
	return mg:IsExists(c213456047.fusfil2,1,c,c:GetAttribute(),c:GetLevel())
end
function c213456047.fusfil2(c,attr,lv)
	return c:IsAttribute(attr) and c:GetLevel()==lv
end
function c213456047.fscon(e,g,gc)
	if g==nil then return true end
	local mg=g:Filter(c213456047.filter,gc,e:GetHandler())
	if gc then return c213456047.filter(gc,e:GetHandler()) and c213456047.fusfil(gc,mg) end
	return mg:IsExists(c213456047.fusfil,1,nil,mg)
end
function c213456047.fsop(e,tp,eg,ep,ev,re,r,rp,gc)
	local mg=eg:Filter(c213456047.filter,gc,e:GetHandler())
	local g1=nil
	local mc=gc
	if not gc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g1=mg:FilterSelect(tp,c213456047.fusfil,1,1,nil,mg)
		mc=g1:GetFirst()
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=mg:FilterSelect(tp,c213456047.fusfil2,1,1,mc,mc:GetAttribute(),mc:GetLevel())
	if g1 then g2:Merge(g1) end
	Duel.SetFusionMaterial(g2)
end

function c213456047.atkfil(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION)
end
function c213456047.atkval(e,c)
	return Duel.GetMatchingGroupCount(c213456047.atkfil,e:GetHandlerPlayer(),LOCATION_MZONE,0,nil)*500
end

function c213456047.pcfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
end
function c213456047.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	local seq=e:GetHandler():GetSequence()
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_SZONE,13-seq)
		and Duel.IsExistingMatchingCard(c213456047.pcfilter,tp,LOCATION_DECK,0,1,nil) end
end
function c213456047.pcop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local seq=e:GetHandler():GetSequence()
	if not Duel.CheckLocation(tp,LOCATION_SZONE,13-seq) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c213456047.pcfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end

function c213456047.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(Card.IsControler,1,nil,c:GetControler()) and g:IsExists(Card.IsControler,1,nil,1-c:GetControler()) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function c213456047.vencon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()==1
end
function c213456047.venfil(c)
	return c:IsFaceup() and c:IsLevelBelow(7)
end
function c213456047.ventg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c213456047.venfil,tp,0,LOCATION_MZONE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,g:GetCount()*1000)
end
function c213456047.venop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c213456047.venfil,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local ct=0
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=e1:Clone()
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			tc:RegisterEffect(e3)
		end
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_ATTACK_FINAL)
		e4:SetValue(0)
		tc:RegisterEffect(e4)
		local e5=e4:Clone()
		e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
		tc:RegisterEffect(e5)
		tc=g:GetNext()
		ct=ct+1
	end
	Duel.Damage(1-tp,ct*1000,REASON_EFFECT)
end

function c213456047.pencon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT+REASON_BATTLE)~=0 and e:GetHandler():IsPreviousLocation(LOCATION_MZONE)
end
function c213456047.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lsc=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rsc=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g=Group.FromCards(lsc,rsc):Filter(aux.TRUE,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c213456047.penop(e,tp,eg,ep,ev,re,r,rp)
	local lsc=Duel.GetFieldCard(tp,LOCATION_SZONE,6)
	local rsc=Duel.GetFieldCard(tp,LOCATION_SZONE,7)
	local g=Group.FromCards(lsc,rsc)
	if Duel.Destroy(g,REASON_EFFECT)~=0 and e:GetHandler():IsRelateToEffect(e) then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
