--分裂の魔術師
--Fission Magician
--Created and scripted by Eerie Code
function c213456027.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c213456027.splimit)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCountLimit(1)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetTarget(c213456027.cntg)
	e2:SetOperation(c213456027.cnop)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,213456027)
	e3:SetCost(c213456027.descost)
	e3:SetTarget(c213456027.destg)
	e3:SetOperation(c213456027.desop)
	c:RegisterEffect(e3)
end

function c213456027.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsAttribute(ATTRIBUTE_DARK) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM and c:IsLocation(LOCATION_HAND)
end

function c213456027.cnfil1(c,tp)
	return c:IsFaceup() and c:IsLevelAbove(5) and c:IsAbleToChangeControler() and Duel.IsExistingTarget(c213456027.cnfil2,tp,LOCATION_MZONE,0,1,c,c)
end
function c213456027.cnfil2(c,lc)
	if c:IsFaceup() and c:IsLevelAbove(5) and not (c:IsAttribute(lc:GetAttribute()) and c:IsRace(lc:GetRace() and c:GetLevel()==lc:GetLevel() and c:GetAttack()==lc:GetAttack())) then
		if Card.GetDefence then
			return c:GetDefence()~=lc:GetDefence()
		else
			return c:GetDefense()~=lc:GetDefense()
		end
	else
		return false
	end
end
function c213456027.cntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c213456027.cnfil1,tp,LOCATION_MZONE,0,1,nil,tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g1=Duel.SelectTarget(tp,c213456027.cnfil1,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tc1=g1:GetFirst()
	e:SetLabelObject(tc1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g2=Duel.SelectTarget(tp,c213456027.cnfil2,tp,LOCATION_MZONE,0,1,1,tc1,tc1)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g1,1,0,0)
end
function c213456027.cnop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or Duel.GetLocationCount(1-tp,LOCATION_MZONE)<1 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=2 then return end
	local lc=g:GetFirst()
	local pc=g:GetNext()
	if pc==e:GetLabelObject() then lc,pc=pc,lc end
	if lc:IsFaceup() and pc:IsFaceup() and Duel.GetControl(lc,1-tp) then
		local lv=lc:GetLevel()
		local atk=lc:GetAttack()
		local def=0
		local cdef=0
		if Card.GetDefence then
			def=lc:GetDefence()
			cdef=EFFECT_SET_DEFENCE_FINAL
		else
			def=lc:GetDefense()
			cdef=EFFECT_SET_DEFENSE_FINAL
		end
		local rc=lc:GetRace()
		local attr=lc:GetAttribute()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(lv)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		pc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		e2:SetValue(atk)
		pc:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(cdef)
		e3:SetValue(def)
		pc:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e4:SetValue(attr)
		pc:RegisterEffect(e4)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_CHANGE_RACE)
		e5:SetValue(rc)
		pc:RegisterEffect(e5)
	end
end

function c213456027.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c213456027.desfil(c)
	return c:GetSummonLocation()==LOCATION_EXTRA and not c:IsType(TYPE_PENDULUM) and c:IsDestructable()
end
function c213456027.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c213456027.desfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c213456027.desfil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c213456027.desfil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c213456027.despfil(c,e,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp)
end
function c213456027.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local g=tc:GetMaterial()
	if Duel.Destroy(tc,REASON_EFFECT,LOCATION_REMOVED)>0 then
		local lc=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
		if not g then return end
		local g=g:Filter(c213456027.despfil,nil,e,tp)
		if g:GetCount()==0 or lc:GetCount()==0 then return end
		local ct=math.min(lc,g:GetCount())
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,ct,ct,nil)
		Duel.SpecialSummon(sg,0,tp,1-tp,false,false,POS_FACEUP)
	end
end
