--古代の機械参頭猟犬
--Triple Ancient Gear Hunting Hound (custom)
--Altered by Raku, scripted by Eerie Code
function c216555051.initial_effect(c)
	c:EnableReviveLimit()
	--Fusion Materials
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c216555051.fuscon)
	e1:SetOperation(c216555051.fusop)
	c:RegisterEffect(e1)
	--multi attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c216555051.mtcon)
	e2:SetOperation(c216555051.mtop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c216555051.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetOperation(c216555051.atkop)
	c:RegisterEffect(e4)
	--
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c216555051.destg)
	e5:SetOperation(c216555051.desop)
	c:RegisterEffect(e5)
end
c216555051.material={7513,216555050}
c216555051.material_count=2

function c216555051.fuscon(e,g,gc,chkf)
	if g==nil then return true end
	if gc then
		local sub=gc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)
		--cb1: Substitute for DBHD, needed 1 more AG monster
		--cb2: AGHD + 2 AG monsters
		--cb3: DBHD + 1 AG monster
		local cb1=(sub and g:IsExists(Card.IsFusionSetCard,1,gc,0x7))
		local cb2=(gc:IsFusionCode(7513) and g:IsExists(Card.IsFusionSetCard,2,gc,0x7))
		local cb3=(gc:IsFusionCode(216555050) and g:IsExists(Card.IsFusionSetCard,1,gc,0x7))
		return cb1 or cb2 or cb3
	end
	local g1=g:Filter(Card.IsFusionSetCard,nil,0x7)
	local g2=g:Filter(Card.IsFusionCode,nil,7513)
	local g3=g:Filter(Card.IsFusionCode,nil,216555050)
	local g4=g:Filter(Card.IsHasEffect,nil,EFFECT_FUSION_SUBSTITUTE)
	local ct1=g1:GetCount()
	local ct2=g2:GetCount()
	local ct3=g3:GetCount()
	local ct4=g4:GetCount()
	local b1=(ct4==0 and ct2>=1 and ct1>=3) --No sub, proc.1
	local b2=(ct4==0 and ct3>=1 and ct1>=2) --No sub, proc.2
	local b3=(ct4>=1 and g4:IsExists(Card.IsFusionSetCard,1,nil,0x7) and ct1>=2) --Substitute is AG, min.1 add. AG
	local b4=(ct4>=1 and not g4:IsExists(Card.IsFusionSetCard,1,nil,0x7) and ct1>=1) --Substitute is not AG, min.2 AG
	if chkf~=PLAYER_NONE then
		return (g1:FilterCount(Card.IsOnField,nil)~=0 or g2:FilterCount(Card.IsOnField,nil)~=0 or g3:FilterCount(Card.IsOnField,nil)~=0 or g4:FilterCount(Card.IsOnField,nil)~=0) and (b1 or b2 or b3 or b4)
	else
		return b1 or b2 or b3 or b4
	end
end
function c216555051.ffilter(c,sb)
	if sb then
		return c:IsFusionSetCard(0x7)
	else
		return c:IsFusionCode(7513,216555050) or c:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)
	end
end
function c216555051.ffilter1(c)
	return c:IsFusionSetCard(0x7) and not c:IsFusionCode(216555050)
end
function c216555051.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local str=_G["Required Materials have been met, select more?"]
	if gc then
		local sub=gc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=eg:FilterSelect(tp,c216555051.ffilter,1,1,gc,sub)
		local tc1=g1:GetFirst()
		local g=eg
		g:RemoveCard(tc1)
		g:RemoveCard(gc)
		sub=gc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE) or tc1:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)
		if gc:IsFusionCode(216555050) or tc1:IsFusionCode(216555050) then
			Duel.SetFusionMaterial(g1)
			return
		end
		if not (gc:IsHasEffect(EFFECT_FUSION_SUBSTITUTE) or tc1:IsHasEffect(EFFECT_FUSION_SUBSTITUTE)) or Duel.SelectYesNo(tp,str) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local g2=g:FilterSelect(tp,c216555051.ffilter,1,1,nil,true)
		end
		Duel.SetFusionMaterial(g1)
		return
	end
	local sg=eg
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=sg:FilterSelect(tp,c216555051.ffilter,1,1,nil,false)
	local tc1=g1:GetFirst()
	sg:RemoveCard(tc1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg:FilterSelect(tp,c216555051.ffilter,1,1,nil,true)
	local tc2=g2:GetFirst()
	g1:Merge(g2)
	sg:RemoveCard(tc2)
	if not g1:IsExists(Card.IsFusionCode,1,nil,216555050) and (not g1:IsExists(Card.IsHasEffect,1,nil,EFFECT_FUSION_SUBSTITUTE) or Duel.SelectYesNo(tp,str)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g3=sg:FilterSelect(tp,c216555051.ffilter1,1,1,nil)
		g1:Merge(g3)
	end
	Duel.SetFusionMaterial(g1)
end

function c216555051.valcheck(e,c)
	local g=c:GetMaterial()
	local ct=0
	ct=ct+g:FilterCount(Card.IsCode,nil,7513)
	ct=ct+(g:FilterCount(Card.IsCode,nil,216555050))*2
	ct=math.min(ct,3)
	e:GetLabelObject():SetLabel(ct)
end
function c216555051.mtcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) and e:GetLabel()>0
end
function c216555051.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	e1:SetValue(ct-1)
	c:RegisterEffect(e1)
end

function c216555051.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c216555051.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c216555051.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end

function c216555051.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c216555051.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
